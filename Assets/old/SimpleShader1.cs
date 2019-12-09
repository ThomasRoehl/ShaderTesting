using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SimpleShader1 : MonoBehaviour
{
    public Material material;
    public Shader normal;
    public Shader protanopia;
    public Shader protanomaly;
    public Shader tutorialPart1;
    public int mode;

    private void OnRenderImage(RenderTexture src, RenderTexture dest) {

        switch (mode)
        {
        case 1:
            material.shader = protanopia;
            break;
        case 2:
            material.shader = protanomaly;
            break;
        case 3:
            material.shader = tutorialPart1;
            break;
        default:
            material.shader = normal;
            break;
        }

        Graphics.Blit(src, dest, material);
    }

    private void Start() {
        normal = Shader.Find("Colorblindness/normal");
        protanopia = Shader.Find("Colorblindness/protanopia");
        protanomaly = Shader.Find("Colorblindness/protanomaly");
        tutorialPart1 = Shader.Find("Tutorial/tutorialPart1");
    }
}
