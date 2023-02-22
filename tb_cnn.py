from os import TMP_MAX
import numpy as np
from decimal import *


def readData(filename, size):
    array = []
    f = open(filename, mode='r')
    for i in range(size):
        line = []
        for j in range(size):
            ele = f.readline().strip('\n')
            bin(int(ele, 16))
            line.append(ele)
        array.append(line)
    f.close()
    return array


def compareFile(file1, file2):
    error = 0
    f1 = open(file1, mode='r')
    f2 = open(file2, mode='r')
    line1 = f1.readline().strip('\n')
    line2 = f2.readline().strip('\n')
    line = 0
    errorlist = []
    while (line1):
        line += 1
        if(line1 != line2):
            error += 1
            errorlist.append([line, line1, line2])
        line1 = f1.readline().strip('\n')
        line2 = f2.readline().strip('\n')
    f1.close
    f2.close
    print(errorlist)
    print('Number of incorrect data of \'', file1,
          '\' and \'', file2, '\' is', error)
    return


def imageTransform(image, height, width):
    floatdata = [[] for i in range(width)]
    for i in range(height):
        for j in range(width):
            temp = image[i, j]
            floatdata[i].append(hex2bin(temp, 5))
    return floatdata


def weightTransform(weight, height, width):
    floatdata = [[] for i in range(width)]
    for i in range(height):
        for j in range(width):
            temp = weight[i, j]
            floatdata[i].append(hex2bin(temp, 4))
    return floatdata


def hex2bin(h, b):  # h是原来的数，b是小数位数，默认有符号
    tempint = int(h, 16)
    '''
    neg = False
    if(tempint >> 7):
        # print(tempint)
        tempint = ~tempint + 1
        # print(tempint)
        neg = True
        # print('neg')
    tempfloat = float(0)
    for i in range(7):
        if (tempint & (1 << i)):
            tempfloat += 2**(i-b)
    if(neg):
        tempfloat = -tempfloat
    '''
    if tempint > 127:
        tempint -= 256
    tempfloat = tempint / 2**b
    return tempfloat


def conv(image, weight):
    result = [[] for i in range(64)]
    image = np.array(image)
    for i in range(64):
        for j in range(64):
            temp = image[i:i + 3, j:j + 3]
            temp = np.multiply(temp, weight)
            result[i].append(temp.sum())
    return result


def cutoff(feature):
    output = [[] for i in range(64)]
    for i in range(64):
        for j in range(64):
            temp = feature[i][j]*2
            if(temp >= 127):
                output[i].append(127)
                continue
            if(temp <= -128):
                output[i].append(128)
                continue
            if(temp < 0):
                temp += 256
            temp = Decimal(temp).quantize(Decimal('0'),rounding=ROUND_HALF_UP)#严格四舍五入
            output[i].append(temp)

    return output


def writeashex(cutoffed):
    file = open('output_python.txt', 'w')
    for i in range(64):
        for j in range(64):
            temp = int(cutoffed[i][j])
            if(temp==256):
                temp=0
            hexed = '{:02x}'.format(temp)            
            file.write("{}\n".format(hexed))
    file.close()
    return


if __name__ == '__main__':
    image_data = readData('image_data.txt', 66)
    weight_data = readData('weight_data.txt', 3)
    # print(image_data)
    # print (weight_data)
    image_data = np.array(image_data)
    weight_data = np.array(weight_data)
    image = imageTransform(image_data, 66, 66)
    weight = weightTransform(weight_data, 3, 3)
    # print(weight)
    
    feature = conv(image, weight)
    # print(feature[4][7])
    cutoffed = cutoff(feature)
    # print(cutoffed[4][7])
    writeashex(cutoffed)
    compareFile('output_python.txt', 'cnn_output.txt')
    # compareFile('cnn_output.txt', 'conv_cutoff_out.txt')
    # compareFile('conv_data_out.txt', '1output_python.txt')
