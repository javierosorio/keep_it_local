# UN Data Annotations

This directory contains annotated sentences from the UN Parallel Corpus v1.0[[1]](#1) in English, Spanish, and Arabic. Each sentence was labelled as a political interaction within the QuadClass schema.

| | Cooperation | Conflict |
| --- | --- | --- |
| Verbal | Verbal Cooperation | Verbal Conflict |
| Material | Material Cooperation | Material Conflict

If a sentence did not fit into this schema, it was labelled as irrelevant.

JSON Files directly from the annotation software Label Studio are located in the directory JSON. TSVs for use in downstream tasks are located in the directories quadclass (for multi-class classification) and binary (for binary relevant vs. irrelevant classification). Within the quadclass and binary directories, files are available both for each language and bundled in one file.

The script that converts JSON files is also in this directory for reproducibility and for use if updates to the data files are required. process_json_to_csv.py requires one argument, the directory that contains the JSON files.

Included are 3 types of files for feeding into the downstream tasks:
* Multi-class - tsv containing the text field and a field with a number for each coded category
    * 0 = Irrelevant
    * 1 = Verbal Conflict
    * 2 = Material Conflict
    * 3 = Verbal Cooperation
    * 4 = Material Cooperation
* Multi-class one-hot - tsv containing the text field and a binary vector with a field for each coded category. For use in multi-class classification if one-hot binary vector format is preferred
* Binary - tsv containing the text field and a field for relevancy (0 = irrelevant, 1 = relevant). For binary classification

## References
<a id="1">[1]</a> 
Ziemski, M., Junczys-Dowmunt, M., and Pouliquen, B., (2016), The United Nations Parallel Corpus, Language Resources and Evaluation (LREC’16), Portorož, Slovenia, May 2016.