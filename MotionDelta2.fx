//Skeleton taken from "Crosire" on the ReShade forums. Modified from there to get the effect to work.
//https://reshade.me/forum/shader-discussion/69-access-to-previous-frames
#include "ReShade.fxh"

texture2D currTex : COLOR;
texture2D cleanTex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
texture2D prev1Tex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
texture2D prev2Tex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
texture2D prev3Tex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
texture2D prev4Tex { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
sampler2D currColor { Texture = currTex; };
sampler2D prev1Color { Texture = prev1Tex; };
sampler2D prev2Color { Texture = prev2Tex; };
sampler2D prev3Color { Texture = prev3Tex; };
sampler2D prev4Color { Texture = prev4Tex; };
sampler2D cleanColor { Texture = cleanTex; };

uniform float blendfrac <
    ui_min = 0.0f; ui_max = 0.999f;
    ui_label = "Blending Fraction";
    ui_type = "slider";
    ui_tooltip = "Adjust amount of previous frame in current frame.";
> = 0.5f;

uniform float scaledelta <
    ui_min = 0.0f; ui_max = 0.999f;
    ui_label = "Delta Multiplier";
    ui_type = "Increase the Magnitude of the delta between frames.";
    ui_tooltip = "Adjust amount of previous frame in current frame.";
> = 0.5f;

float4 PS_MotionDelta(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	float4 curr = tex2D(currColor, texcoord);
	float4 prev1 = tex2D(prev1Color, texcoord);
	float4 prev2 = tex2D(prev2Color, texcoord);
	float4 prev3 = tex2D(prev3Color, texcoord);
	float4 prev4 = tex2D(prev4Color, texcoord);
	
	float4 delta = (0.0f,0.0f,0.0f,0.0f);
	float4 out4 = curr;
	
	delta = curr-(prev1+prev2+prev3+prev4)*0.25f;
	
	out4 = lerp(curr, saturate(curr+delta*scaledelta), blendfrac);
	//out4 = lerp(curr, (0.5f,0.5f,0.5f,1.0f)+delta*scaledelta, blendfrac);	
	
	return (out4);
}
float4 PS_CopyFrame(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	return tex2D(currColor, texcoord);
}
float4 PS_CopyClean(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	return tex2D(cleanColor, texcoord);
}
float4 PS_CopyP1(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	return tex2D(prev1Color, texcoord);
}
float4 PS_CopyP2(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	return tex2D(prev2Color, texcoord);
}
float4 PS_CopyP3(float4 vpos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	return tex2D(prev3Color, texcoord);
}


technique MotionDelta2
{
	pass DoCopyCleanFrame
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_CopyFrame;
		RenderTarget = cleanTex;
	}
	pass DoPostProcessing
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_MotionDelta;
		// prevTex = cleanTex;
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
		PixelShader = PS_CopyClean;
		RenderTarget = prev1Tex;
	}
}