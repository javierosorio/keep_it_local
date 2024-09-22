# Translation Scripts for  Google API, Deep, and OPUS Transformers
This directory contains 3 scripts for performing machine translations of text data using the tools: Deep Translator, Google API, and OPUS Transformers. These scripts take input files in the form of TSV files, translate them from one language to another (e.g., English to Arabic or Spanish), and save the translated output to new TSV files.
Tools Used for Translation
1.	Google API: Utilizes the Google Cloud Translate API for translation.  
2.	Deep Translator: Uses the deep-translator library to translate text.  
3.	OPUS Transformers: Uses a pre-trained transformer model from the Hugging Face library for translation.  
### Scripts Overview
### 1. Google API Translation Script
### •	Script:
Ar_Google-New-Updated_Comb.ipynb  
### •	Description: 
This script uses the Google Cloud Translate API to translate English text into Arabic. It loads data from a TSV file, translates each sentence, and saves the translated text to a new file.  
### •	Key Features:
o	Google Cloud API: Uses the translate_v2 API from Google Cloud.    
o	API Credentials: Requires the user to set up and provide Google Cloud credentials in the environment.    
### •	Input File:
o	Path: /home/user/en_annotations_binary_complete.tsv
### •	Output File:
o	Path: /home/user/Google_Ar_En_binary_complete.tsv
### 2. Deep Translator Script
### •	Script:
Ar_Deep-New-Comb.ipynb  
### •	Description: 
This script uses the deep-translator library to translate English text into Arabic. It processes the input TSV file, translates each sentence, and outputs the translated text to a new TSV file.  
### •	Input File:  
o	Path: /home/user/Input_File.tsv  
### •	Output File:  
o	Path: /home/user/Deep_En_Ar_Completed_Translated.tsv  
### 3. OPUS Transformers Translation Script
### •	Script: 
Ar_TransformersTask1-New-Comb.ipynb  
### •	Description:
This script uses the OPUS Transformers model (MarianMT) from the Hugging Face library to translate English text into Spanish. The script loads the text from a TSV file, translates it using a pre-trained model, and outputs the translated text to a new TSV file.  
### •	Key Features:  
o	Model: Utilizes the Helsinki-NLP/opus-mt-en-es model for translation from English to Spanish.  
o	Tokenizer and Model: Uses MarianTokenizer and MarianMTModel for tokenization and translation.    
### •	Input File:  
o	Path: /home/user/en_annotations_binary_complete.tsv  
### •	Output File:  
o	Path: /home/user/Transformers_En_ES_complete.tsv  
________________________________________
### To Run Each Script
### 1. Running the Google API Translation Script
1.	Install necessary packages:
Copy code:
```
 pip install pandas google-cloud-translate
```
2.	Set up Google Cloud credentials and provide the path to the credentials file:
                export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/google/credentials.json"
3.	Update the input and output files paths in the script:
4.	Run the script to perform the translation.
### 2. Running the Deep Translator Script
1.	Install necessary packages:
   Copy code:
```
   pip install deep-translator pandas
```
2.	Update the input and output files paths in the script:
3.	Run the script to perform the translation.
### 3. Running the OPUS Transformers Script
1.	Install necessary packages:
```
   pip install transformers pandas torch sentencepiece
 ```
2.	Update the input and output files paths in the script:
3.	Run the script to perform the translation.
________________________________________
### Dependencies
Required Libraries  
•	pandas  
•	deep-translator  
•	google-cloud-translate  
•	transformers  
•	torch  
•	sentencepiece  

Installation Instructions
Copy code:
```
pip install pandas deep-translator google-cloud-translate transformers torch sentencepiece
```
Make sure the necessary API credentials are configured for the Google API script.
________________________________________
### Notes
•	Error Handling: In all scripts, if a translation fails for a specific sentence, the original sentence is retained in the output file.  
•	Chunking for Long Texts: The Deep Translator script handles long texts by chunking them if they exceed the API's length limitations.  
•	Language Options: The OPUS Transformers script can be modified to translate between different languages by changing the model used (e.g., using opus-mt-en-de for English to German).  

