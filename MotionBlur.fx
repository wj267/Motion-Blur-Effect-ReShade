//Skeleton taken from "Crosire" on the ReShade forums. I just defined what the Pixel Shader section should actually do.
//https://reshade.me/forum/shader-discussion/69-access-to-previous-frames
#include "ReShade.fxh"

texture2D currTex : COLOR;
texture2D prevTex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
sampler2D currColor { Texture = currTex; };
sampler2D prevColor { Texture = prevTex; };

//Setting Blend Frac to 1 essentially frezes rendering.
uniform float blendfrac <
    ui_min = 0.0f; ui_max = 0.999f;
    ui_label = "Blending Fraction";
    ui_type = "slider";
    ui_tooltip = "Adjust amount of previous frame in current frame.";
> = 0.5f;

float4 PS_MotionBlur(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	float4 curr = tex2D(currColor, texcoord);
	float4 prev = tex2D(prevColor, texcoord);

	float4 out4 = curr;
	
	out4 = lerp(curr, prev, blendfrac);


	return (out4);
}
float4 PS_CopyFrame(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	return tex2D(currColor, texcoord);
}

technique MotionBlur
{
	pass DoPostProcessing
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_MotionBlur;
	}
	pass DoCopyFrameForPrevAccess
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_CopyFrame;
		RenderTarget = prevTex;
	}
}