Shader "Colorblindness/protanopia"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            struct newcolor
            {
                float r;
                float g;
                float b;
            };

            newcolor calculate(float values[9], fixed4 col) {
                newcolor newcol;
                newcol.r = col.r * values[0] + col.g * values[1] + col.b * values[2];
                newcol.g = col.r * values[3] + col.g * values[4] + col.b * values[5];
                newcol.b = col.r * values[6] + col.g * values[7] + col.b * values[8];
                return newcol;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                float protanopia[9] = {0.56667,0.43333,0, 0.55833,0.44167,0, 0,0.24167,0.75833};
                newcolor newcol = calculate(protanopia, col);
                col.r = newcol.r;
                col.g = newcol.g;
                col.b = newcol.b;
                return col;
            }
            ENDCG
        }
    }
}
