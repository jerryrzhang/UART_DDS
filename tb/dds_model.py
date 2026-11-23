import numpy as np

def build_lut():
    lut = np.arange(1024)

    vals = np.sin(lut * (np.pi / (2 ** 11))) * ((2 ** 15) - 1) + 0.5

    table =  vals.astype(np.int16)
    return table



def generate_array(ftw, n):
    if ftw < 0 or ftw >= 2 ** 32:
        raise ValueError("FTW must be between 0 and 2^32")

    lut = build_lut()
    output = np.zeros(n, dtype = np.int16)

    k = np.arange(n, dtype = np.uint32)

    acc = k * np.uint32(ftw)

    lut_index_12b = acc >> 20

    quadrant = lut_index_12b >> 10 #grab two left bits
    index = lut_index_12b & 0x3FF #grab ten right bits

    # 00, 01, 10, 11

    for i in range(n):
        match quadrant[i]:
            case 0:
                output[i] = lut[index[i]]
            case 1:
                output[i] = lut[1023 - index[i]]
            case 2:
                output[i] = -lut[index[i]]
            case 3:
                output[i] = -lut[1023 - index[i]]
        
    #     count += 1
    #     if count == 1023:
    #         count = 0
    #         quadrant = (quadrant + 1) % 4
    print(output)
    return output

if __name__ == "__main__":
    generate_array(2 ** 32 // 64, 600)