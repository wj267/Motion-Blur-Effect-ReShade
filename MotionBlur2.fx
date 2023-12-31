//Skeleton taken from "Crosire" on the ReShade forums. I just defined what the Pixel Shader section should actually do.
//https://reshade.me/forum/shader-discussion/69-access-to-previous-frames
#include "ReShade.fxh"

texture2D currTex : COLOR;
texture2D prev1Tex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
texture2D prev2Tex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
texture2D prev3Tex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
texture2D prev4Tex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
sampler2D currColor { Texture = currTex; };
sampler2D prev1Color { Texture = prev1Tex; };
sampler2D prev2Color { Texture = prev2Tex; };
sampler2D prev3Color { Texture = prev3Tex; };
sampler2D prev4Color { Texture = prev4Tex; };


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
	float4 prev1 = tex2D(prev1Color, texcoord);
	float4 prev2 = tex2D(prev2Color, texcoord);
	float4 prev3 = tex2D(prev3Color, texcoord);
	float4 prev4 = tex2D(prev4Color, texcoord);

	float4 out4 = curr;
	
	prev3 = lerp(prev4, prev3, blendfrac);
	prev2 = lerp(prev3, prev2, blendfrac);
	prev1 = lerp(prev2, prev1, blendfrac);
	out4 = lerp(curr, prev1, blendfrac);


	return (out4);
}
float4 PS_CopyFrame(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	return tex2D(currColor, texcoord);
}
float4 PS_CopyP1(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	return tex2D(currColor, texcoord);
}
float4 PS_CopyP2(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	return tex2D(currColor, texcoord);
}
float4 PS_CopyP3(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	return tex2D(currColor, texcoord);
}

technique MotionBlur2
{
	pass DoPostProcessing
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_MotionBlur;
	}
	pass DoCopyFrameForPrev4
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_CopyP3;
		RenderTarget = prev4Tex;
	}
	pass DoCopyFrameForPrev3
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_CopyP2;
		RenderTarget = prev3Tex;
	}
	pass DoCopyFrameForPrev2
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_CopyP1;
		RenderTarget = prev2Tex;
	}
	pass DoCopyFrameForPrev1
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_CopyFrame;
		RenderTarget = prev1Tex;
	}
}