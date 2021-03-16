#!/usr/local/bin/python3.6
# -*- coding: utf-8 -*-

import os
import pandas as pd 


def readFromCSV(path):

    # with open(path,"r") as csvfile:
    #     reader = csv.reader(csvfile)
    #     rows = [row for row in reader]
    df = pd.read_csv(path)

    return df


def run(rows):
    num = 0
    for i in range(len(rows.index)):
        #print(rows.loc[i][0], rows.loc[i][1])
    
        try:
            results = os.popen("python3 octopus_wasm -r " + rows.loc[i][3] + " -s")
            result = results.read()
            print(rows.loc[i][0], rows.loc[i][1], rows.loc[i][2],'\n')

        except:
            with open('./temp/' + str(i),'w') as f:
                f.write(rows.loc[i][3])

    for filename in os.listdir('./temp'):
        try:
            results = os.popen("python3 octopus_wasm -rf ./temp/" + filename + " -s")
            result = results.read() 
            os.remove('./temp/' + filename)
            print(rows.loc[int(filename)][0], rows.loc[int(filename)][1], rows.loc[int(filename)][2],'\n') 
        except:
            os.remove('./temp/' + filename)
            continue
    

if __name__ == '__main__':
    rows = readFromCSV('~/Desktop/EOS_all.csv')
    run(rows)