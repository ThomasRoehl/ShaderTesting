Shader "EyeProblem/centerRotation"
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
                // Rotate
                float rfAngle = 0;
                float Temp;
                float Tcos;
                float Tsin;
                i.uv.x = i.uv.x-0.5;
                i.uv.y = i.uv.y-0.5;
                rfAngle =  radians(rfAngle);
                Tcos = cos(rfAngle);
                Tsin = sin(rfAngle);
                Temp = i.uv.x * Tcos - i.uv.y * Tsin + 0.5;
                i.uv.y = i.uv.y * Tcos + i.uv.x * Tsin + 0.5;
                i.uv.x = Temp;
                // END Rotate


                // Squeeze
                float Dist;
                float Angle;
                float fAngle = 2; // 2
                float fCoeff = .9; // .9
                Dist = distance(i.uv.xy, float2(0.5,0.5)) * 2;
                if (Dist < 1.0){
                    Angle = atan2(i.uv.y - 0.5, i.uv.x - 0.5) + pow(1 - Dist,2) * fAngle;
                    Dist = (pow(Dist,fCoeff)) / 2;
                    i.uv.x = cos(Angle) * Dist + 0.5;
                    i.uv.y = sin(Angle) * Dist + 0.5;
                }
                // END Squeeze

                fixed4 col = tex2D(_MainTex, i.uv);
                // just invert the colors
                // col.rgb = 1 - col.rgb;
                return col;
            }
            ENDCG
        }
    }
}
