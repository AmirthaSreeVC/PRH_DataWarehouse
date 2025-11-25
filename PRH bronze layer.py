# sample json to sql
import requests
import pandas as pd
from sqlalchemy import create_engine
from datetime import datetime
import time
#'AUDIO','DK.COM','PRH.CA','PRH.US','SALESINTERNATIONAL'
domains = ['AUDIO','DK.COM','PRH.CA','PRH.US','SALESINTERNATIONAL']
connection_uri='mssql+pyodbc://@DESKTOP-J8R2HPQ\\SQLEXPRESS/PRH_Warehouse?trusted_connection=yes&driver=ODBC+Driver+17+for+SQL+Server'
engine = create_engine(connection_uri)
                

class Tables:                

        def extract(self,table_name,path="",rows=0): 
                total_start_time = datetime.now()
                full_data = pd.DataFrame()
                print("-------------------Data Extraction: "+table_name+"-------------------------")               
                for domain in domains:
                        start_time = datetime.now()
                        print(">>> Data Extraction: "+table_name+"_"+domain)
                        c=''
                        c='2' if rows!=0 else '0'                
                        url = "https://api.penguinrandomhouse.com/resources/v2/title/domains/"+domain+"/"+table_name.lower()+path+"?suppressLinks=true&rows="+c+"&api_key=dghk9ckmufrkzsz5rww5r4qc"
                        try:
                                
                                r = requests.get(url)
                                if r.status_code !=200:
                                        print('API failed at '+c+' trying again')
                                        time.sleep(1)
                                        i=5
                                        while i > 0:
                                                r = requests.get(url)
                                                if r.status_code == 200: 
                                                        print('API Successful')
                                                        break
                                                i-=1
                                                time.sleep(2)
                                if r.status_code != 200: 
                                        print('Failed to load data')
                                
                                json_data = r.json()
                                if table_name[len(table_name)-1] != 's': table_name+'s'
                                full_data = pd.json_normalize(json_data['data'][table_name])
                                
                        except TypeError as e:
                                print(e.__traceback__)

                        if rows!=0:
                                count = json_data['recordCount']
                                for j in range(2,count,rows):  
                                        try:
                                                url = "https://api.penguinrandomhouse.com/resources/v2/title/domains/"+domain+"/"+table_name.lower()+path+"?suppressLinks=true&suppressRecordCount=true&start="+str(j)+"&rows="+str(rows)+"&api_key=dghk9ckmufrkzsz5rww5r4qc"
                                                          
                                                r = requests.get(url)
                                                if r.status_code !=200:
                                                        print(f'API failed to load {j} to {j+rows} trying again')
                                                        time.sleep(2)
                                                        i=5
                                                        while i > 0:
                                                                r = requests.get(url)
                                                                if r.status_code == 200: 
                                                                        print('API Successful')
                                                                        break
                                                                i-=1
                                                                time.sleep(2)
                                                if r.status_code != 200: 
                                                        print('Failed to load data')
                                                        continue
                                                json_data = r.json()
                                                
                                        except TypeError as e:
                                                print(e.__traceback__)
                                                
                                        if table_name[len(table_name)-1] != 's': table_name+'s'
                                        if table_name != 'works':
                                                data = pd.json_normalize(json_data['data'][table_name])
                                        else: data = pd.json_normalize(json_data['data'])
                                        
                                        
                                        if data.empty:
                                                print("Couldn't find the data")
                                                continue
                                        full_data=pd.concat([full_data if not full_data.empty else None
                                                             ,data],ignore_index=True)
                                        

                       
                        print(f'>>>>>>>> {domain} data length: {0}',len(full_data))
                        print(full_data.head())
                        full_data.to_sql(table_name+'_'+domain,con=engine,if_exists='replace',index=False)
                        end_time = datetime.now()
                        print(">>>>>>>> Data Extraction: "+table_name+"_"+domain+" Completed Successfully")
                        print(f">>>>>>>> Load Duration: {(end_time - start_time).seconds} seconds")
                        
                total_end_time = datetime.now()
                print(f'>>>>>>>>>>Total Duration: {(total_end_time-total_start_time).seconds} seconds')
    
    

if __name__ == '__main__':
        overall_start_time = datetime.now()
        t = Tables()
        small_tables = ['roles','events','catSets','series']
        #large_tables = ['categories','title','works','authors']
        for i in range(0,len(small_tables)):
                t.extract(small_tables[i])
                if i%2==0:
                        time.sleep(1)

        
        #t.extract('titles',rows=1000)
        #t.extract('authors',path='/views/list-display',rows=5000) 
        #t.extract('works',path='/views/ant',rows=2000)  
        #t.extract('categories',rows=300)
        engine.dispose()
        overall_end_time = datetime.now()
        print(f'>>>>Overall Duration: {(overall_end_time-overall_start_time).seconds} seconds')

        