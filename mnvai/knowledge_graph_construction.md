# To construct a knowledge graph #
## 1. Information Extraction
### Entity Extraction 实体抽取 
- 即命名实体识别，Named Entity Recognition (NER)
- 从文本数据集中自动识别出（一系列离散）命名实体
- Recall & Precision
- 模型方法
    * 已知实体实例进行特征建模 > 利用该模型处理海量数据集得到新的命名实体列表 > 针对新实体建模 > 迭代生成实体标注语料库
    * 根据搜索引擎的服务器日志，基于实体的语义特征从搜索日志中识别出命名实体 > 聚类算法对识别出的实体对象进行聚类
### Relation Extraction
    人工构造语法和语义规则（模式匹配）
    统计机器学习方法
    基于特征向量或核函数的有监督学习方法
    研究重点转向半监督和无监督
    开始研究面向开放域的信息抽取方法
    将面向开放域的信息抽取方法和面向封闭领域的传统方法结合
### Attribute Extraction
## 2. Knowledge Fusion

## 3. Knowledge Processing


