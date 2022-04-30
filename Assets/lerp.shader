Shader "Custom/lerp"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MainTex2 ("Albedo (RGB)", 2D) = "white" {}
        _lerpTest ("lerp test", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard 

        sampler2D _MainTex;
        sampler2D _MainTex2;
        float _lerpTest;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MainTex2;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D (_MainTex2, IN.uv_MainTex2);
            // o.Albedo = lerp(c.rgb, d.rgb, 0); // 선형보간 상에서 0은 c.rgb 를 가리키므로, _MainTex 에 담긴 텍스쳐의 텍셀값만 할당될거임.
            // o.Albedo = lerp(c.rgb, d.rgb, 1); // 선형보간 상에서 1은 d.rgb 를 가리키므로, _MainTex2 에 담긴 텍스쳐의 텍셀값만 할당될거임.
            // o.Albedo = lerp(c.rgb, d.rgb, 0.5); // 선형보간 상에서 0.5 는 c.rgb 와 d.rgb 텍셀값의 중간지점으로 보간된 rgb 값을 리턴해주므로, '두 텍셀값이 섞인 색상'으로 나올거임!
            o.Albedo = lerp(c.rgb, d.rgb, _lerpTest); // lerp() 함수의 마지막 인자인 비율값을 유니티 인터페이스로 입력받아서 선형보간의 비율을 조절할 수 있도록 한 것!
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
