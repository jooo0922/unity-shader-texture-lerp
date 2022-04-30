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
            // o.Albedo = lerp(c.rgb, d.rgb, 0); // �������� �󿡼� 0�� c.rgb �� ����Ű�Ƿ�, _MainTex �� ��� �ؽ����� �ؼ����� �Ҵ�ɰ���.
            // o.Albedo = lerp(c.rgb, d.rgb, 1); // �������� �󿡼� 1�� d.rgb �� ����Ű�Ƿ�, _MainTex2 �� ��� �ؽ����� �ؼ����� �Ҵ�ɰ���.
            // o.Albedo = lerp(c.rgb, d.rgb, 0.5); // �������� �󿡼� 0.5 �� c.rgb �� d.rgb �ؼ����� �߰��������� ������ rgb ���� �������ֹǷ�, '�� �ؼ����� ���� ����'���� ���ð���!
            o.Albedo = lerp(c.rgb, d.rgb, _lerpTest); // lerp() �Լ��� ������ ������ �������� ����Ƽ �������̽��� �Է¹޾Ƽ� ���������� ������ ������ �� �ֵ��� �� ��!
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
