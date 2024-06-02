'''
File: process_json_to_tsv.py
Author: Amber Converse
Purpose: This script converts the exported JSON from Label Studio to tsvs for
    downstream tasks. The following types of files are created:
        * Multi-Label - tsv containing the text field and a binary vector with a field for
            each coded category. For mult-label classification only
        * Multi-Class - tsv containing the text field and a field with a number for each
            coded category (0 = irrelvant, 1 = VerConf, 2 = MatConf, 3 = VerCoop, 4 = MatCoop)
        * Multi-Class One-Hot Binary Version - tsv containing the text field and a binary vector
            with a field for each coded category. This file is distinct from the multi-label version
            because the vector is a one hot binary vector, so texts with multiple labels have been
            excluded. For multi-class classification if one-hot binary vector format is preferred
        * Binary - tsv containing the text field and a field for relevancy (0 = irrelevant,
            1 = relevant). For binary classification
    Requires 2
'''

import csv
import json
from pathlib import Path
import glob
from sklearn.preprocessing import MultiLabelBinarizer
import argparse

def read_json(json_file):
    
    text_labels = []
    invalid_annotations = 0
    
    with open(json_file, 'r') as json_file:

        tasks = json.load(json_file)

        total_tasks = len(tasks)
        for task in tasks:
            
            task_annotations = []
            
            ground_truth = False
            for annotator in task["annotations"]:
                if annotator["ground_truth"]:
                    ground_truth = True
                    for annotation in annotator["result"]:
                        if annotation["type"] == "taxonomy":
                            for label in annotation["value"]["taxonomy"]:
                                task_annotations.append(label[0])
                                
            if ground_truth:
                text_labels.append([[task["data"]["en"], task["data"]["es"], task["data"]["ar"]], task_annotations])
            elif task["agreement"] == 100:
                    for annotation in task["annotations"][0]["result"]:
                        if annotation["type"] == "taxonomy":
                            for label in annotation["value"]["taxonomy"]:
                                task_annotations.append(label[0])
                    text_labels.append([[task["data"]["en"], task["data"]["es"], task["data"]["ar"]], task_annotations])
            else:
                invalid_annotations += 1

    print(f"Discarded {invalid_annotations} invalid labels.")
    print(f"Loss of {invalid_annotations / total_tasks * 100}% of annotations.")
    return text_labels

def write_multilabel(texts, labels, dir):

    with open(Path(dir) / "quadclass/all_annotations_quad_multilabel.tsv", "w") as f:
        csv_writer = csv.writer(f, delimiter="\t", quotechar='"')
        csv_writer.writerow(["en","es","ar","MatConf","MatCoop","VerConf","VerCoop"])
        for i in range(len(texts)):
            csv_writer.writerow([texts[i][0],texts[i][1],texts[i][2], \
                                labels[i][0],labels[i][1], \
                                labels[i][2],labels[i][3]])
    
    for j, lang in enumerate(["en","es","ar"]):
        with open(Path(dir) / f"quadclass/{lang}/{lang}_annotations_quad_multilabel.tsv", "w") as f:
            csv_writer = csv.writer(f, delimiter="\t", quotechar='"')
            csv_writer.writerow([lang,"MatConf","MatCoop","VerConf","VerCoop"])
            for i in range(len(texts)):
                csv_writer.writerow([texts[i][j], \
                                    labels[i][0],labels[i][1], \
                                    labels[i][2],labels[i][3]])
            
def write_multiclass(texts, labels, dir):

    with open(Path(dir) / "quadclass/all_annotations_quad_multiclass.tsv", "w") as f:
        csv_writer = csv.writer(f, delimiter="\t", quotechar='"')
        csv_writer.writerow(["en","es","ar","QuadClass"])
        for i in range(len(texts)):
            if sum(labels[i]) < 2:
                csv_writer.writerow([texts[i][0],texts[i][1],texts[i][2], \
                                    0 if sum(labels[i]) == 0 else (labels[i] == 1).nonzero()[0][0] + 1])

    # Write One Hot Binary Version     
    with open(Path(dir) / "quadclass/all_annotations_quad_multiclass_ONE_HOT.tsv", "w") as f:
        csv_writer = csv.writer(f, delimiter="\t", quotechar='"')
        csv_writer.writerow(["en","es","ar","MatConf","MatCoop","VerConf","VerCoop"])
        for i in range(len(texts)):
            if sum(labels[i]) < 2:
                csv_writer.writerow([texts[i][0],texts[i][1],texts[i][2], \
                                    labels[i][0],labels[i][1], \
                                    labels[i][2],labels[i][3]])
    
    for j, lang in enumerate(["en","es","ar"]):
        with open(Path(dir) / f"quadclass/{lang}/{lang}_annotations_quad_multiclass.tsv", "w") as f:
            csv_writer = csv.writer(f, delimiter="\t", quotechar='"')
            csv_writer.writerow([lang,"QuadClass"])
            for i in range(len(texts)):
                if sum(labels[i]) < 2:
                    csv_writer.writerow([texts[i][j], \
                                        0 if sum(labels[i]) == 0 else (labels[i] == 1).nonzero()[0][0] + 1])
        
        # Write One Hot Binary Version
        with open(Path(dir) / f"quadclass/{lang}/{lang}_annotations_quad_multiclass_ONE_HOT.tsv", "w") as f:
            csv_writer = csv.writer(f, delimiter="\t", quotechar='"')
            csv_writer.writerow([lang,"MatConf","MatCoop","VerConf","VerCoop"])
            for i in range(len(texts)):
                if sum(labels[i]) < 2:
                    csv_writer.writerow([texts[i][j], \
                                        labels[i][0],labels[i][1], \
                                        labels[i][2],labels[i][3]])  

def write_binary(texts, labels, dir):

    with open(Path(dir) / "binary/all_annotations_binary.tsv", "w") as f:
        csv_writer = csv.writer(f, delimiter="\t", quotechar='"')
        csv_writer.writerow(["en","es","ar","Relevant"])
        for i in range(len(texts)):
            relevant_irrelevant = 0 if sum(labels[i]) == 0 else 1
            csv_writer.writerow([texts[i][0],texts[i][1],texts[i][2], relevant_irrelevant])

    for j, lang in enumerate(["en","es","ar"]):
        with open(Path(dir) / f"binary/{lang}/{lang}_annotations_binary.tsv", "w") as f:
            csv_writer = csv.writer(f, delimiter="\t", quotechar='"')
            csv_writer.writerow([lang,"Relevant"])
            for i in range(len(texts)):
                relevant_irrelevant = 0 if sum(labels[i]) == 0 else 1
                csv_writer.writerow([texts[i][j], relevant_irrelevant])

def main():

    parser = argparse.ArgumentParser(
                    prog="Process JSON to TSV",
                    description="This script converts the exported JSON from Label Studio to tsvs for downstream tasks.",)
    parser.add_argument("json_dir")
    
    json_dir = parser.parse_args().json_dir

    texts = []
    labels = []
    for json_file in glob.glob(f"{json_dir}/*.json"):
        cur_texts, cur_labels = zip(*read_json(json_file))
        texts += cur_texts
        labels += cur_labels
        print(len(texts))

    valid_labels = ["Verbal Conflict", "Material Conflict", \
                    "Verbal Cooperation", "Material Cooperation"]
    
    mlb = MultiLabelBinarizer()
    mlb.fit([valid_labels])

    binarized_labels = mlb.fit_transform(labels)
    
    dir = Path(json_dir).parents[0]

    write_multilabel(texts, binarized_labels, dir)

    write_multiclass(texts, binarized_labels, dir)

    write_binary(texts, binarized_labels, dir)

if __name__ == "__main__":
    main()