# Translation Quality Evaluation Script
This script assesses the translation quality of 4 Machine Translation (MT) tools: Deep, DeepL, Google API, and OPUS Transformers by comparing machine-translated sentences to a reference file using the following metrics: BLEU, SacreBLEU, METEOR, and BERTScore. and outputs results into 6 specific CSV files and one PDF report containing plots and regression analysis. The script supports multiple language options, in this script, Arabic is the example language.
### Language Options
This script evaluates translations for different languages noting while using the BERTScore metric (which requires specifying the target language). As an example for the project explanation, Arabic is used as the evaluation language.
To switch between languages, the lang parameter in the calculate_bertscore function and the output file naming need to be modified to the preferred language code.
For example, the code for Arabic:
```
calculate_bertscore(references, candidates, lang="ar")
```
If using another language, replace "ar" with the appropriate language code (e.g., "en" for English or "es" for Spanish).
### Input and Output
### Input Files
The script requires two input TSV (Tab-Separated Values) files:
1.	Original file: A TSV file containing the reference or called original (human-translated in this project) Arabic sentences.
2.	Translated file: A TSV file containing the machine-translated sentences corresponding to the original Arabic sentences.
Both files should be properly formatted as TSV files, where each row contains one sentence.
### Output Files
The script generates the following output files for each of the translations provided by the 4 translation tools, as an example Deep will be used here:
1.	Translation Scores CSV (Arabic_Deep_Ar_Translation_Scores.csv):
This file contains the BLEU, SacreBLEU, METEOR, and BERTScore for each sentence in the machine-translated output compared to the reference sentences.
2.	Not Found Sentences CSV (Deep_Ar_Not_Found_Sentences.csv):
This file lists sentences missing from the translated file compared to the original, showing the difference in sentence count between the two files.
3.	Sentence Differences CSV (Deep_Ar_Sentence_Differences.csv):
A file detailing sentences that are present in the original file but missing in the translated file.
4.	Detailed Translation Metrics CSV (Arabic_Deep_Ar_Detailed_Translation_Metrics.csv):
This file contains the detailed scores for all metrics (BLEU, SacreBLEU, METEOR, and BERTScore) for each sentence, along with regression statistics.
5.	Translation Statistics CSV (Arabic_Deep_Ar_Translation_Statistics.csv):
This file contains regression statistics (slope, intercept, R-value, p-value, standard error) for each quality metric.
6.	PDF Report (Arabic_Translation_Quality_Report.pdf):
This file contains visualizations for the BLEU, SacreBLEU, METEOR, and BERTScore metrics, along with linear regression analysis for each metric over the sentences.
________________________________________
### Quality Metrics
### 1. BLEU Score
•	The script uses the BLEU (Bilingual Evaluation Understudy) score to measure n-gram overlap between machine-generated translations and reference translations.  
•	For each sentence, the BLEU score is computed using the NLTK library, with smoothing applied to prevent zero scores for shorter sentences.  
•	The individual BLEU scores are saved in the Translation Scores CSV file, along with other metric scores.  
### 2. SacreBLEU
•	The SacreBLEU metric is a standardized version of BLEU, designed to ensure consistent evaluation across various translation tasks.  
•	It computes the SacreBLEU score for each sentence, providing a normalized score that allows fair comparisons between different translation systems.  
•	The SacreBLEU scores for all sentences are included in the Translation Scores CSV file.  
### 3. METEOR Score
•	METEOR (Metric for Evaluation of Translation with Explicit ORdering) calculates translation quality by considering synonyms, stemming, and word order.  
•	The script computes the METEOR score for each sentence and stores the results in the Translation Scores CSV.  
### 4. BERTScore
•	The BERTScore uses pre-trained BERT embeddings to measure the semantic similarity between machine-translated and reference sentences.  
•	This score captures the contextual meaning of the translations, providing a more advanced metric than BLEU or METEOR.  
•	The BERTScore for each sentence is included in the Translation Scores CSV.
________________________________________
### Plotting
The script generates the following plots, which are saved in the PDF Report:
### 1. Individual Metric Plots with Regression
•	For each metric (BLEU, SacreBLEU, METEOR, and BERTScore), the script generates scatter plots showing the metric scores for each sentence.  
•	A linear regression line is fitted to the data to show trends in the metric scores across the sentences.  
•	Regression statistics, such as slope, intercept, R-value, p-value, and standard error, are displayed at the bottom of the plots.  
### 2. Combined Metric Plot
•	In addition to individual metric plots, the script generates a combined line plot showing all 4 metrics (BLEU, SacreBLEU, METEOR, and BERTScore) for each sentence.  
•	The combined plot also includes regression statistics for each metric.  
•	This plot allows for easy comparison of the different metrics' performance across the sentences.  
### 3. Missing Sentences Bar Plot
•	A bar plot is created showing the number of missing sentences in the translated file compared to the original file.  
•	This plot is useful for visualizing discrepancies between the number of sentences in the two files.  
________________________________________
### Detailed Reports
### 1. Translation Scores CSV (Arabic_Deep_Ar_Translation_Scores.csv)
•	This CSV file contains the BLEU, SacreBLEU, METEOR, and BERTScore for each sentence in the translated text.  
•	Each row corresponds to a single sentence, and each column corresponds to a specific metric score.  
### 2. Not Found Sentences CSV (Deep_Ar_Not_Found_Sentences.csv)
•	This CSV file lists the number of sentences found in the original file but missing in the translated file.  
•	The file includes the sentence counts for both the original and translated files, and the number of missing sentences for each.  
### 3. Sentence Differences CSV (Deep_Ar_Sentence_Differences.csv)
•	This file lists sentences that are present in the original file but missing in the translated file.  
•	It identifies the sentence number and the missing sentence from the original text.  
### 4. Translation Statistics CSV (Arabic_Deep_Ar_Translation_Statistics.csv)
•	This file provides detailed regression statistics for each metric (BLEU, SacreBLEU, METEOR, BERTScore), including slope, intercept, R-value, p-value, and standard error.  
### 5. Detailed Translation Metrics CSV (Arabic_Deep_Ar_Detailed_Translation_Metrics.csv)
•	Contains detailed sentence-by-sentence metric scores for all four evaluation metrics.  
•	This file is useful for in-depth analysis of the translation quality on a per-sentence basis.  
________________________________________
### To Run the Script
1.	Ensure you have the necessary dependencies installed:
Copy code:
```
pip install pandas nltk sacrebleu bert_score matplotlib seaborn scipy
```
3.	Update the file paths in the script to point to your original and translated TSV files:
Copy code:
```
original_file = '/path/to/original_file.tsv'  
translated_file = '/path/to/translated_file.tsv'
```
3.	Run the script:
Copy code:
python <script_name.py>
4.	After running the script, you will find the output files in the same directory as the script. These include the six CSV files with metric scores, sentence differences, and translation statistics, as well as the PDF report with visualizations.

