👤 Autor
Fernando de Paula
Proyecto: Federation SDDM Theme
Repositorio: https://github.com/DSPaula/Federation

# Federation — Tema SDDM para FreeBSD 14.3+ y Qt 6.5

**Federation** es un tema moderno y adaptable para el gestor de inicio de sesión **SDDM**, desarrollado con **QtQuick 6.5**, **SddmComponents 2.0** y diseñado para **FreeBSD 14.3 o superior**.  
Ofrece una interfaz limpia, escalable y visualmente coherente con entornos como KDE Plasma o LXQt.

---

## 🧠 Características principales

- Compatibilidad total con **Qt 6.5** y **SddmComponents 2.0**
- Integración con **FreeBSD 14.3+**
- Tipografías compactas: *CompactaBT*, *Helvetica Ultra Compacta*, *Tahoma*
- Fondo personalizable (`TierraPlana.jpg`)
- Botones SVG con estados hover y pressed
- Archivos QML modulares (`Main.qml`, `Clock2.qml`)
- Configuración simple mediante `theme.conf`
- Licencia abierta (GPLv3)

---

## ⚙️ Requisitos del sistema

| Componente | Requisito mínimo |
|-------------|------------------|
| **Sistema operativo** | FreeBSD 14.3 o superior |
| **Gestor de sesión** | SDDM ≥ 0.20 |
| **Bibliotecas Qt** | QtQuick 6.5, QtQuick.Controls 6.5, QtQuick.Layouts 6.5 |
| **Módulos SDDM** | SddmComponents 2.0 |
| **Hardware recomendado** | GPU con aceleración OpenGL, resolución ≥ 1366×768 |

---

## 🧩 Instalación

```bash
# Clonar el repositorio
git clone https://github.com/DSPaula/Federation.git
cd Federation

# Crear directorio del tema
sudo mkdir -p /usr/local/share/sddm/themes/Federation

# Copiar archivos
sudo cp -r * /usr/local/share/sddm/themes/Federation

# Configurar SDDM
sudo ee /usr/local/etc/sddm.conf
# Añadir:
# [Theme]
# Current=Federation

🧪 Prueba local (sin instalar)
cd Federation
sddm-greeter --test-mode --theme $(pwd)


