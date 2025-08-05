# 🎨 Godot Toon Shader (SoME Submission)

This project was created as a submission for **SoME — Summer of Math Exposition**, an event by 3Blue1Brown that celebrates fun, experimental, and educational math-related projects.

This is a minimal Godot project that demonstrates a basic **toon shader** (cell shading) using Godot Shading Language.

> Note -  It is, however, a little bit scuffed — the focus was on experimenting and learning.

---

## 📁 Included Files

| File                  | Description                                      |
|-----------------------|--------------------------------------------------|
| `toon.gdshader`       | Core toon shader code                            |
| `toon.gdshader.uid`   | Godot’s internal resource UID                    |
| `depth_map.gdshader`  | Depth map shader code                            |
| `project.godot`       | Minimal Godot 4 project file                     |

---

## Preview
- passing depth map
<img width="1249" height="826" alt="Screenshot 2025-08-05 210622" src="https://github.com/user-attachments/assets/a3226ed1-8937-4c6e-8f3d-d7a60335c4e6" /> 
<img width="1323" height="840" alt="Screenshot 2025-08-05 210331" src="https://github.com/user-attachments/assets/7d1659b0-ee95-4722-b83f-622ec2ef180f" />

- passing the overall toon shader
  
<img width="1906" height="926" alt="p1" src="https://github.com/user-attachments/assets/1ea657f4-a4b9-4c8b-b167-74a1a9db98d6" />
<img width="1916" height="918" alt="p3" src="https://github.com/user-attachments/assets/fa90d602-55af-4c62-8080-ce633567bc51" />

## 🎯 Purpose

The goal of this SoME entry was to explore:
- How mathematical concepts such as matrices are used in Godot shaders 
- Visual stylisation with cell/toon shading
- The creative overlap between graphics programming and mathematics (especially light quantisation, gradients, and normals)

---

## 🚀 How to Use

1. Open this project in **Godot 4.x**
2. Apply the `toon.gdshader` to a 3D material
3. Customise and experiment!

---

## 🧠 Why It’s Relevant to Math

While shaders are visual, they’re deeply mathematical — lighting models, dot products, quantisation, and gradients all require math thinking.  
This project plays with how **light intensity maps to discrete steps** — a concept similar to quantization and piecewise functions.

---




