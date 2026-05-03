import torch #
from transformers import pipeline #
from PIL import Image
import requests
import matplotlib.pyplot as plt


device = "cuda" if torch.cuda.is_available() else "cpu" #set device as GPU if available

print("Loading Depth-anything V1 model")
pipe = pipeline(task="depth-estimation", model="LiheYoung/depth-anything-base-hf", device=device) #load model

image = Image.open("3D_Illusions/forced_perspective/Ames_room_forced_perspective")

result = pipe(image)
depth_map = result["depth"]

fig, axes = plt.subplots(1, 2, figsize=(12, 6))
axes[0].imshow(image)
axes[0].set_title("Imagen Original (Ilusión)", fontsize=14)
axes[0].axis('off')

# Mapa de profundidad
# Usamos el mapa de color 'inferno' (colores cálidos cerca, oscuros lejos)
axes[1].imshow(depth_map, cmap='inferno') 
axes[1].set_title("Mapa de Profundidad (Depth Anything V1)", fontsize=14)
axes[1].axis('off')

plt.tight_layout()
plt.show()

