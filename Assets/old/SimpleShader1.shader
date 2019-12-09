Shader "Custom/SimpleShader1"
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
                // just invert the colors
                float normal[9] = {1,0,0, 0,1,0, 0,0,1};
                float protanopia[9] = {0.56667,0.43333,0, 0.55833,0.44167,0, 0,0.24167,0.75833};
                float protanomaly[9] = {0.81667,0.18333,0, 0.33333,0.66667,0, 0,0.125,0.875};
                float deuteranopia[9] = {0.625,0.375,0, 0.70,0.30,0, 0,0.30,0.70};
                float deuteranomaly[9] = {0.80,0.20,0, 0.25833,0.74167,0, 0,0.14167,0.85833};
                float tritanopia[9] = {0.95,0.5,0, 0,0.43333,0.56667, 0,0.475,0.525};
                float tritanomaly[9] = {0.96667,0.3333,0, 0,0.73333,0.26667, 0,0.18333,0.81667};
                float achromatopsia[9] = {0.299,0.587,0.114, 0.299,0.587,0.114, 0.299,0.587,0.114};
                float achromatomaly[9] = {0.618,0.32,0.62, 0.163,0.775,0.62, 0.163,0.320,0.516};

                newcolor newcol = calculate(deuteranopia, col);
                col.r = newcol.r;
                col.g = newcol.g;
                col.b = newcol.b;
                return col;
            }
            ENDCG
        }
    }
}
