import os
import json
import base64

current_dir = os.path.dirname(os.path.abspath(__file__))
config_path = os.path.join(current_dir, "config.json")

with open(config_path, "r") as f:
    config = json.load(f)
    os.environ["OPENAI_API_KEY"] = config["openai_api_key"]

print("GETTOKEN: ", os.environ["OPENAI_API_KEY"])

from langchain_openai import ChatOpenAI

model = ChatOpenAI(model="gpt-4o")

from typing import Optional

from langchain_core.pydantic_v1 import BaseModel, Field

class Advice(BaseModel):
    """用户建议。"""
    star: int = Field(description="建议的星级评分，范围从1到5", ge=1, le=5)
    summary: str = Field(description="建议的简要总结")
    content: str = Field(description="建议的详细内容和注意事项")
    purpose: str = Field(description="建议的设计考虑和目的（注意结合数据和植物图片）")

class AdviceList(BaseModel):
    """建议列表。"""
    advices: list[Advice] = Field(description="建议列表，长度应至少为3")

class Advice2(BaseModel):
    """改善结果。"""
    major_improvement: str = Field(description="最大的改善方面，一个很简洁的文本")
    improvement_details: list[str] = Field(description="具体改善情况的列表，每个元素都是文字，表示改善方面（注意结合数据和植物图片）")

class FinalAdvice(BaseModel):
    advice_list: AdviceList
    result: Advice2

structured_llm = model.with_structured_output(FinalAdvice)

def encode_image(image_path):
  with open(image_path, "rb") as image_file:
    return base64.b64encode(image_file.read()).decode('utf-8')

example_output = """{
  "advice_list": {
    "advices": [
      {
        "star": 5,
        "content": "增加光照",
        "purpose": "您的植物目前光照不足，建议每天增加2小时的阳光直射，这将有助于提高叶片的光合作用效率。"
      },
      {
        "star": 4,
        "content": "调整土壤pH值",
        "purpose": "叶氮含量偏低，可能与土壤的pH值不适宜有关，建议调整土壤至微酸性以促进氮的吸收。"
      },
      {
        "star": 3,
        "content": "增加浇水频率",
        "purpose": "植物高度生长缓慢，可能是由于土壤过于干燥，建议增加浇水频率，但避免积水。"
      }
    ]
  },
  "result": {
    "major_improvement": "植物整体健康状态显著提升",
    "improvement_details": [
      "叶片光合作用效率提高",
      "植物高度增长加快",
      "土壤养分吸收改善"
    ]
  }
}"""

def predict_gpt(image_path, analysis_result):
  base64_image = encode_image(image_path)
  base64_image = f"data:image/jpeg;base64,{base64_image}"
  prompt = f"""
你是一名出色的植物医生。
**植物医生设计说明**
植物医生采用友好且随意的语气，为园丁和植物爱好者提供简洁、个性化的帮助。它记住用户的偏好和过去的互动，以提供更符合用户需求的建议。当用户上传植物图片时，它会分析植物的当前健康状况，并考虑任何以前的问题或给出的建议，确保提供全面的护理计划。植物医生能够识别各种问题，从疾病到护理错误，并以易于理解的方式提供解决方案。它适用于各种类型的植物，因而对所有园艺水平的用户都很实用。此外，当用户感到困惑时，植物医生还提供图片或视觉辅助以帮助理解。它注重提供简洁、清晰的指示，使建议易于遵循和应用。在每次互动结束时，植物医生鼓励满意的用户与他人分享他们的积极结果，促进一个分享和学习的社区。
**任务描述**
请根据以下植物特性数据和图片，给出详细的植物养护建议，并按重要程度给予每个建议星级（⭐️-⭐️⭐️⭐️⭐️⭐️）。最后，告诉用户遵守这些建议后，植物会在哪些方面得到最大的改善。
### 植物特性数据：
{analysis_result}
### 植物图片：
![image]({base64_image})
"""
  result = (structured_llm.invoke(prompt))
  print(result)
  return str(result.json())
