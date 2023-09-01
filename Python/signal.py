#Python3 code for signal file generation
import numpy as np

# Pre-code
Fs = 100
Ts = 1 / Fs
Bits = 8  # Bits used in conversion

# Time Vector
t = np.arange(0, 1, Ts)

# Signal
m = np.sin(2 * np.pi * t) + 2.5 * np.cos(2 * np.pi * t * 4 + np.pi / 7)
import matplotlib.pyplot as plt

plt.plot(t, m)
plt.grid()
plt.title("Signal")
plt.xlabel("Time [s]")
plt.ylabel("Amplitude [V]")
plt.show()

# Conditioning
m = m + abs(np.min(m))  # Positive Offset
Out = (m / np.max(m)) * ((2**Bits) - 1)  # Normalization and Codification
# Exporting
Outbin = [format(int(round(value)), '08b') for value in Out]  # Decimal to Binary conversion

with open(r'/home/tiago/Downloads/signal.txt', 'w') as fp:
        fp.write("\n".join(str(item) for item in Outbin))
 
