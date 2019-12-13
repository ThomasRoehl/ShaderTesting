Shader "EyeProblem/blackSpot2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Darkness ("Darkness", Range(0,1)) = .5
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
            float _Darkness;

            fixed4 frag (v2f i) : SV_Target
            { 
                fixed4 col = tex2D(_MainTex, i.uv);
                if (_Darkness == 0) return col;
                float dist = distance(i.uv.xy, float2(0.5,0.5));

                float darkcol = 1-(sin(pow(dist,2)) * 4.5 * (1-_Darkness));
                col.rgb = lerp(col.rgb, float3(0,0,0), darkcol);

                return col;
            }
            ENDCG
        }
    }
}
