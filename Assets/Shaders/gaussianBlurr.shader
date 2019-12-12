Shader "EyeProblem/gaussianBlurr"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _StandardDeviation("Standard Deviation", Range(0, 0.1)) = 0.02
        _Samples ("Samples", Range(1,100)) = 10
        _Intensity ("Intensity", Range(0,0.1)) = 0
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

            #define PI 3.14159265359
            #define E 2.71828182846

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
            float _StandardDeviation;
            float _Intensity;
            int _Samples;

            fixed4 frag (v2f i) : SV_Target
            {                
                if(_StandardDeviation == 0 || _Samples < 2) return tex2D(_MainTex, i.uv);
                float sum = 0;
				float4 col = 0;
                for(float index = 0; index < _Samples; index++){
					//get the offset of the sample
					float offset = (index/(_Samples-1) - 0.5) * _Intensity;
					//get uv coordinate of sample
					float2 uv = i.uv + float2(0, offset);
                    float stDevSquared = _StandardDeviation*_StandardDeviation;
                    float gauss = (1 / sqrt(2*PI*stDevSquared)) * pow(E, -((offset*offset)/(2*stDevSquared)));
                    //add result to sum
                    sum += gauss;
                    //multiply color with influence from gaussian function and add it to sum color
                    col += tex2D(_MainTex, uv) * gauss;
                }
                col = col / sum;

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

            #define PI 3.14159265359
            #define E 2.71828182846

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
            float _StandardDeviation;
            int _Samples;
            float _Intensity;

            fixed4 frag (v2f i) : SV_Target
            {
                if(_StandardDeviation == 0 || _Samples < 2) return tex2D(_MainTex, i.uv);
                float sum = 0;
                float invAspect = _ScreenParams.y / _ScreenParams.x;
				float4 col = 0;
                for(float index = 0; index < _Samples; index++){
					//get the offset of the sample
					float offset = (index/(_Samples-1) - 0.5) * _Intensity * invAspect;
					//get uv coordinate of sample
					float2 uv = i.uv + float2(offset, 0);
                    float stDevSquared = _StandardDeviation*_StandardDeviation;
                    float gauss = (1 / sqrt(2*PI*stDevSquared)) * pow(E, -((offset*offset)/(2*stDevSquared)));
                    //add result to sum
                    sum += gauss;
                    //multiply color with influence from gaussian function and add it to sum color
                    col += tex2D(_MainTex, uv) * gauss;
                }
                col = col / sum;

                return col;
            }
            ENDCG
        }
    }
}
