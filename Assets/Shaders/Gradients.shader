Shader "Unlit/Gradients"
{
	Properties
	{
		//_MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _Color1("Color 1", Color) = (1.0,1.0,1.0,1.0)
        _Color2("Color 2", Color) = (1.0,1.0,1.0,1.0)
        _Color3("Color 3", Color) = (1.0,1.0,1.0,1.0)
        _Center("Center", Vector) = (0.5,0.5,0.0,0.0)
    }

	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent"}
		LOD 100

		Pass
		{
            Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
            #pragma target 3.0
			
			#include "UnityCG.cginc"
            #include "noiseSimplex.cginc"
            

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
                float2 normal: NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};
            
            sampler2D _NoiseTex;
            fixed4 _Color1, _Color2, _Color3;
            float4 _Center;
            
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
                //o.vertex.x += snoise(v.normal.yy + _Time.yy/10)/10;
                o.uv = v.uv;
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

                //fixed4 noiseValue = tex2D(_NoiseTex, i.uv * 0.3 + _Time.x);
              
                float dist = distance(_Center.xy, i.uv);
                fixed4 col = lerp(_Color1, _Color2, snoise(i.uv*2 + _Time.xy/5));   
                col = lerp(col, _Color3, snoise(i.uv * snoise(_Time.yz/10)/3 + _Time.xy/10));
 
				// apply fog
                col.a = 1.0;
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}

           


			ENDCG
		}
	}
}
