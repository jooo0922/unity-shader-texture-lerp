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
            // o.Albedo = lerp(c.rgb, d.rgb, _lerpTest); // lerp() �Լ��� ������ ������ �������� ����Ƽ �������̽��� �Է¹޾Ƽ� ���������� ������ ������ �� �ֵ��� �� ��!

            // _MainTex(Ǯ �ؽ�ó)�� ����Ƽ�� Ȯ���غ��� ���� ä���� �ִٴ� ���� �� �� ����. 
            // ����ä�ο��� ǥ���� �������� 0, ����� 1, �߰��߰� ȸ���� �� ������ ����� ��ġȭ�� �� ����. 
            // c(�ؼ���)�� ���� �� �ؼ��� ���� ����ä�ΰ� c.a �� ������ �ְ�, �� ���� �ؼ� ��ġ�� ���� 0 ~ 1 ������ �����̰���.
            // ���� �� ���� lerp() �Լ��� ������ ������ �������� �־��ָ� ��� �ɱ�?
            // o.Albedo = lerp(c.rgb, d.rgb, c.a); // c.a �� 0�� ��, �� ����ä�� �󿡼� ������(���) ������ c.rgb �� �Ҵ�ǰ�, c.a�� 1�� ��, ��, ����ä�� �󿡼� ���(Ǯ) ������ d.rgb �� �Ҵ�Ǽ� ������!
            // o.Albedo = lerp(c.rgb, d.rgb, 1 - c.a); // ���� 1 - c.a �� �Ѵٸ�? ���� ����� �ڹٲ� ���·� ��������! ��� ������ (1 - 0 = 1) �̴� d.rgb �� �Ҵ�ǰ�, Ǯ ������ (1 - 1 = 0) �̴� c.rgb �� �Ҵ�ǰ���!
            o.Albedo = lerp(d.rgb, c.rgb, c.a); // �̷��� d.rgb�� c.rgb �� ��ġ�� �ڹٲ㵵 1 - c.a �� �� �Ͱ� ������ ����� ����!
            // �̷� ������ �̿��ϸ� ���� �ؽ��Ŀ� � �ڱ��̳� ����, ��ũ ���� ���ִܳ� ����� ������ �� �ִٰ� ��!

            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
