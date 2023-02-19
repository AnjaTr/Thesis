import shutil

import numpy as np
import pandas as pd
import argparse
import os


# Program for separating metadata and expression values from MACSIMA dataset
def main():
    print('Starting separation')
    # Parsing arguments/ files
    parser = argparse.ArgumentParser(prog='data_separator')

    parser.add_argument('-f', nargs=1, help='PATH_TO_(.csv)_FILE', required=True)

    args = parser.parse_args()

    # Read arguments
    file_path = args.f[0]

    if not os.path.exists(file_path):
        parser.error("File not found!")
    else:
        # read data
        print('Reading Data...')

        data = pd.read_csv(file_path, index_col="ID")
        # get filename (without the .csv) for later saving
        filename = file_path.split('/')[-1][:-4]
        path = '/'.join(file_path.split('/')[:-1]) + '/' + filename + '_DATA'

        # create new directory for resulting datasets
        if os.path.exists(path):
            shutil.rmtree(path)
        os.makedirs(path)

        # separate dataset
        # search for all columns that have the word "Exp" in it -> expression values
        print('Saving Expression Values')
        expression_data = data.filter(regex=("Exp"))

        # save expression values
        exp = expression_data.filter(regex=("Cell Exp")) #.to_csv(path + '/' + filename + '_EXPRESSION.csv', sep='\t')

        # remove "Cell Exp" from gene name for later
        exp.columns = exp.columns.str.replace(' Cell Exp', '')

        # save updated table
        exp.to_csv(path + '/' + filename + '_EXPRESSION.csv', sep='\t')

        # save cytoplasm expression values
        expression_data.filter(regex=("Cyto Exp")).to_csv(path + '/' + filename + '_CYTO_EXPRESSION.csv', sep='\t')
        # save nucleii expression values
        expression_data.filter(regex=("Nuc Exp")).to_csv(path + '/' + filename + '_NUC_EXPRESSION.csv', sep='\t')

        # drop expression columns to get metadata
        print('Saving Meta Data')
        data = data.drop(expression_data.columns, axis=1)
        data.to_csv(path + '/' + filename + '_METADATA.csv', sep='\t')
        print('Done. Files save in directory ' + path)


if __name__ == "__main__":
    main()
