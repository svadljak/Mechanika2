import numpy as np
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider, Button

# Konstanty a počáteční hodnoty
g = 9.81  # gravitační zrychlení [m/s²]
h0 = 300.0        # počáteční výška [m]
v_A0_0 = 100.0    # počáteční rychlost [m/s]
phi_0_0 = np.pi/6 # počáteční úhel [rad]

def compute_trajectory(h, v_A0, phi_0, num_points=200):
    """
    Vypočítá dráhu střely.
    Vrací: čas, x, y, celkový čas letu T.
    """
    # Vypočet času dopadu pomocí kvadratické rovnice:
    # h + v_A0*sin(phi_0)*t - 0.5*g*t² = 0
    B = v_A0 * np.sin(phi_0)
    D_sqrt = np.sqrt(B**2 + 2 * g * h)
    T1 = (B + D_sqrt) / g
    T2 = (B - D_sqrt) / g
    T_candidates = [T for T in [T1, T2] if T >= 0]
    T = min(T_candidates) if T_candidates else 0
    
    t = np.linspace(0, T, num_points)
    x = v_A0 * np.cos(phi_0) * t
    y = h + v_A0 * np.sin(phi_0) * t - 0.5 * g * t**2
    return t, x, y, T

# Inicializace grafu
t, x, y, T = compute_trajectory(h0, v_A0_0, phi_0_0)
fig, ax = plt.subplots()
plt.subplots_adjust(left=0.25, bottom=0.35)
[line] = ax.plot(x, y, lw=2)
ax.set_xlabel('x [m]')
ax.set_ylabel('y [m]')
ax.set_title('Dráha střely')
ax.grid(True)
ax.set_xlim(0, 2000)  # Nastavení počátečního limitu osy x na 2000
ax.set_ylim(0, 700)   # Nastavení pevného limitu osy y na 700


# Nastavení posuvníků
axcolor = 'lightgoldenrodyellow'
ax_h = plt.axes([0.25, 0.25, 0.65, 0.03], facecolor=axcolor)
ax_v = plt.axes([0.25, 0.20, 0.65, 0.03], facecolor=axcolor)
ax_phi = plt.axes([0.25, 0.15, 0.65, 0.03], facecolor=axcolor)

slider_h = Slider(ax_h, 'h [m]', 0, 500, valinit=h0)
slider_v = Slider(ax_v, 'v_A0 [m/s]', 0, 200, valinit=v_A0_0)
slider_phi = Slider(ax_phi, 'phi_0 [rad]', 0, np.pi/2, valinit=phi_0_0)

def update(val):
    h_val = slider_h.val
    v_val = slider_v.val
    phi_val = slider_phi.val
    t, x, y, T_new = compute_trajectory(h_val, v_val, phi_val)
    line.set_data(x, y)
    
    # Nastavení limitu osy x - minimálně 2000, ale i větší pokud je potřeba
    max_x = max(x)*1.1 if len(x)>0 else 0
    ax.set_xlim(0, max(2000, max_x))
    
    # Pevný limit osy y na 700
    ax.set_ylim(0, 700)
    fig.canvas.draw_idle()

slider_h.on_changed(update)
slider_v.on_changed(update)
slider_phi.on_changed(update)

# Tlačítko pro reset hodnot
resetax = plt.axes([0.8, 0.025, 0.1, 0.04])
button = Button(resetax, 'Reset', color=axcolor, hovercolor='0.975')

def reset(event):
    slider_h.reset()
    slider_v.reset()
    slider_phi.reset()
button.on_clicked(reset)

plt.show()
