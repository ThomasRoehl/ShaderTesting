using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CameraModes : MonoBehaviour
{
    public Material material;
    public Shader normal;
    public Shader protanopia;
    public Shader protanomaly;
    public Shader tutorialPart1;
    public Shader centerRotation;
    public Shader blackSpot;
    public Shader blackSpot2;
    public Shader whiteSpot;
    public Shader boxBlurr;
    public Shader gaussianBlurr;
    public int mode;

    private void OnRenderImage(RenderTexture src, RenderTexture dest) {

        RenderTexture temporaryTexture;

        switch (mode)
        {
        case 1:
            material.shader = protanopia;
            Graphics.Blit(src, dest, material);
            break;
        case 2:
            material.shader = protanomaly;
            Graphics.Blit(src, dest, material);
            break;
        case 3:
            material.shader = tutorialPart1;
            Graphics.Blit(src, dest, material);
            break;
        case 4:
            material.shader = centerRotation;
            Graphics.Blit(src, dest, material);
            break;
        case 5:
            material.shader = blackSpot;
            Graphics.Blit(src, dest, material);
            break;
        case 6:
            material.shader = blackSpot2;
            Graphics.Blit(src, dest, material);
            break;
        case 7:
            material.shader = whiteSpot;
            Graphics.Blit(src, dest, material);
            break;
        case 8:
            material.shader = boxBlurr;
            temporaryTexture = RenderTexture.GetTemporary(src.width, src.height);
            Graphics.Blit(src, temporaryTexture, material, 0);
            Graphics.Blit(temporaryTexture, dest, material, 1);
            break;
        case 9:
            material.shader = gaussianBlurr;
            temporaryTexture = RenderTexture.GetTemporary(src.width, src.height);
            Graphics.Blit(src, temporaryTexture, material, 0);
            Graphics.Blit(temporaryTexture, dest, material, 1);
            break;
        default:
            material.shader = normal;
            Graphics.Blit(src, dest, material);
            break;
        }
    }

    private void Start() {
        normal = Shader.Find("Colorblindness/normal");
        protanopia = Shader.Find("Colorblindness/protanopia");
        protanomaly = Shader.Find("Colorblindness/protanomaly");
        tutorialPart1 = Shader.Find("Tutorial/tutorialPart1");
        centerRotation = Shader.Find("EyeProblem/centerRotation");
        blackSpot = Shader.Find("EyeProblem/blackSpot");
        blackSpot2 = Shader.Find("EyeProblem/blackSpot2");
        boxBlurr = Shader.Find("EyeProblem/boxBlurr");
        gaussianBlurr = Shader.Find("EyeProblem/gaussianBlurr");
        whiteSpot = Shader.Find("EyeProblem/whiteSpot");
    }
}
