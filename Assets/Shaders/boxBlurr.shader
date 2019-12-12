Shader "EyeProblem/boxBlurr"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Intensity ("Intensity", Range(0,0.1)) = 0
        _Samples ("Samples", Range(1,100)) = 10
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        // Vertical Blurr
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
            float _Intensity;
            int _Samples;

            fixed4 frag (v2f i) : SV_Target
            {                
                float4 col = 0;
                if (_Samples <= 1) return tex2D(_MainTex, i.uv);
                for(float index=0;index<_Samples;index++){
                    float2 uv = i.uv + float2(0, (index/(_Samples-1) - 0.5) * _Intensity);
                    col += tex2D(_MainTex, uv);
                }
                //divide the sum of values by the amount of samples
                col = col / _Samples;

                return col;
            }
            ENDCG
        }

        // Horizontal Blurr
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
            float _Intensity;
            int _Samples;

            fixed4 frag (v2f i) : SV_Target
            {                
                float4 col = 0;
                float invAspect = _ScreenParams.y / _ScreenParams.x;
                if (_Samples <= 1) return tex2D(_MainTex, i.uv);
                for(float index=0;index<_Samples;index++){
                    float2 uv = i.uv + float2((index/(_Samples-1) - 0.5) * _Intensity * invAspect, 0);
                    col += tex2D(_MainTex, uv);
                }
                //divide the sum of values by the amount of samples
                col = col / _Samples;

                return col;
            }
            ENDCG
        }
    }
}
