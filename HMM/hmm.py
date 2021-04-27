import math
import numpy as np


def hmm(x, y, pi, O):
    n = 2
    m = 27
    maximum_iter = 1
    iters = 0
    old_log_prob = -1000000.000

    while iters < maximum_iter:
        # Alpha Pass
        o_size = len(O)
        alpha = np.zeros([o_size, n], dtype=float)
        beta = np.zeros([o_size, n], dtype=float)
        gamma = np.zeros([o_size, n], dtype=float)
        z = np.zeros(o_size, dtype=float)
        gij = np.zeros(o_size, dtype=float)
        # alpha = [[float(0), float(0)] for row in range(o_size)]
        #  = [[float(0), float(0)] for row in range(o_size)]
        #  = [[float(0), float(0)] for row in range(o_size)]
        # z = [float(0) for col in range(o_size)]
        # gij = [float(0) for col in range(o_size)]

        ## Compuying aplha[0]
        for i in range(n):
            alpha[0][i] = pi[0][i] * y[i][O[0]]
            z[0] = z[0] + alpha[0][i]

        ## Scaling alpha[0][i]
        z[0] = 1 / z[0]
        for i in range(n):
            alpha[0][i] = z[0] * alpha[0][i]

        ## computing alpha[i]
        for i in range(1, o_size):
            for j in range(n):
                for k in range(n):
                    alpha[i][j] = alpha[i][j] + alpha[i - 1][k] * x[k][j]
                alpha[i][j] = alpha[i][j] * y[j][O[i]]
                z[i] = z[i] + alpha[i][j]
            z[i] = 1 / z[i]
            for l in range(n):
                alpha[i][l] = z[i] * alpha[i][l]

        # Beta pass
        for i in range(n):
            beta[o_size - 1][i] = z[o_size - 1]

        for i in range(o_size - 2, -1, -1):
            for j in range(n):
                beta[i][j] = 0.0
                for k in range(n):
                    beta[i][j] = beta[i][j] + x[j][k] * y[k][O[i + 1]] * beta[i + 1][k]

                ##scaling beta with same scaling as applied in alpha
                beta[i][j] = z[i] * beta[i][j]

        # Gamma Pass
        for i in range(o_size - 1):
            for j in range(n):
                gamma[i][j] = 0
                for k in range(n):
                    gij[i] = alpha[j][k] * x[j][k] * y[k][O[i + 1]] * beta[i + 1][k]
                    gamma[i][j] = gamma[i][j] + gij[i]

        for i in range(n):
            gamma[o_size - 1][i] = alpha[o_size - 1][i]

        # Re-Estimating pi,x,y
        ## [a] Re-estimating pi
        for i in range(n):
            pi[0][i] = gamma[0][i]

        # [b] Re-estimating x
        for i in range(n):
            denominator = 0
            for j in range(o_size - 1):
                denominator += gamma[j][i]
            for k in range(n):
                numerator = 0
                for l in range(o_size):
                    numerator = numerator + gij[l]
                    # print(numerator)
                # print(denominator, numerator)
                x[i][k] = numerator / denominator

        ##[c] Re-estimating y
        for i in range(n):
            denominator = 0
            for j in range(o_size - 1):
                denominator += gamma[j][i]
            for k in range(0, m - 1):
                numerator = 0
                for l in range(o_size - 1):
                    if O[l] == k:
                        numerator += gamma[l][i]
                # print(i, k)
                y[i][k] = numerator / denominator

        # Computing log(P(O/lambda))
        log_prob = 0
        for i in range(o_size):
            val = z[i]
            log_prob += math.log1p(val)

        log_prob *= -1

        iters += 1
        if iters < maximum_iter and log_prob > old_log_prob:
            old_log_prob = log_prob
        else:
            break
    # print(pi)
    return x, y, pi


if __name__ == "__main__":
    x = [[0.47468, 0.52532], [0.51656, 0.48344]]
    pi = [[0.51316, 0.48684]]
    # print(pi[0][0])
    y = [
        [
            0.03735,
            0.03408,
            0.03455,
            0.03828,
            0.03782,
            0.03922,
            0.03688,
            0.03408,
            0.03875,
            0.04062,
            0.03735,
            0.03968,
            0.03548,
            0.03735,
            0.04062,
            0.03595,
            0.03641,
            0.03408,
            0.04062,
            0.03548,
            0.03922,
            0.04062,
            0.03455,
            0.03595,
            0.03408,
            0.03408,
            0.03688,
        ],
        [
            0.03909,
            0.03537,
            0.03537,
            0.03909,
            0.03583,
            0.03630,
            0.04048,
            0.03537,
            0.03816,
            0.03909,
            0.03490,
            0.03723,
            0.03537,
            0.03909,
            0.03397,
            0.03397,
            0.03816,
            0.03676,
            0.04048,
            0.03443,
            0.03537,
            0.03955,
            0.03816,
            0.03723,
            0.03769,
            0.03955,
            0.03397,
        ],
    ]
    print("Old PI=>", pi)
    print("Old X=>", x)
    print("Old Y=>", y)
    file = open("sample.txt", "r", encoding="utf-8")
    data = []
    iters = 0
    while iters < 1500:
        # read by character
        char = file.read(1)
        if not char:
            break
        if char == "a" or char == "A":
            data.append(0)
        elif char == "b" or char == "B":
            data.append(1)
        elif char == "c" or char == "C":
            data.append(2)
        elif char == "d" or char == "D":
            data.append(3)
        elif char == "e" or char == "E":
            data.append(4)
        elif char == "f" or char == "F":
            data.append(5)
        elif char == "g" or char == "G":
            data.append(6)
        elif char == "h" or char == "H":
            data.append(7)
        elif char == "i" or char == "I":
            data.append(8)
        elif char == "j" or char == "J":
            data.append(9)
        elif char == "k" or char == "K":
            data.append(10)
        elif char == "l" or char == "L":
            data.append(11)
        elif char == "m" or char == "M":
            data.append(12)
        elif char == "n" or char == "N":
            data.append(13)
        elif char == "o" or char == "O":
            data.append(14)
        elif char == "p" or char == "P":
            data.append(15)
        elif char == "q" or char == "Q":
            data.append(16)
        elif char == "r" or char == "R":
            data.append(17)
        elif char == "s" or char == "S":
            data.append(18)
        elif char == "t" or char == "T":
            data.append(19)
        elif char == "u" or char == "U":
            data.append(20)
        elif char == "v" or char == "V":
            data.append(21)
        elif char == "w" or char == "W":
            data.append(22)
        elif char == "x" or char == "X":
            data.append(23)
        elif char == "y" or char == "Y":
            data.append(24)
        elif char == "z" or char == "Z":
            data.append(25)
        elif char == " ":
            data.append(26)
        iters += 1
    file.close()

    new_x, new_y, new_pi = hmm(x, y, pi, data)
    print("\n")
    print("New PI=>", new_pi)
    print("New X=>", new_x)
    print("New Y=>", new_y)
