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
            // o.Albedo = lerp(c.rgb, d.rgb, _lerpTest); // lerp() 함수의 마지막 인자인 비율값을 유니티 인터페이스로 입력받아서 선형보간의 비율을 조절할 수 있도록 한 것!

            // _MainTex(풀 텍스처)을 유니티로 확인해보면 알파 채널이 있다는 것을 알 수 있음. 
            // 알파채널에서 표현된 검정색은 0, 흰색은 1, 중간중간 회색은 그 사이의 값들로 수치화할 수 있음. 
            // c(텍셀값)은 따라서 각 텍셀에 따른 알파채널값 c.a 를 가지고 있고, 이 값은 텍셀 위치에 따라 0 ~ 1 사이의 값들이겠지.
            // 만약 이 값을 lerp() 함수의 마지막 인자인 비율값에 넣어주면 어떻게 될까?
            // o.Albedo = lerp(c.rgb, d.rgb, c.a); // c.a 가 0인 곳, 즉 알파채널 상에서 검정색(배경) 부위는 c.rgb 가 할당되고, c.a가 1인 곳, 즉, 알파채널 상에서 흰색(풀) 부위는 d.rgb 가 할당되서 합쳐짐!
            // o.Albedo = lerp(c.rgb, d.rgb, 1 - c.a); // 만약 1 - c.a 를 한다면? 위의 결과가 뒤바뀐 형태로 나오겠지! 배경 부위는 (1 - 0 = 1) 이니 d.rgb 가 할당되고, 풀 부위는 (1 - 1 = 0) 이니 c.rgb 가 할당되겠지!
            o.Albedo = lerp(d.rgb, c.rgb, c.a); // 이렇게 d.rgb와 c.rgb 의 위치를 뒤바꿔도 1 - c.a 를 한 것과 동일한 결과가 나옴!
            // 이런 원리를 이용하면 벽면 텍스쳐에 어떤 자국이나 무늬, 마크 등을 새겨넣는 기법에 응용할 수 있다고 함!

            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
