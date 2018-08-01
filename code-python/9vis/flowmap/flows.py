#before using this you need to make a link-breaked version of the roads in yoru database with the osm2pgrourting tool. 
#before use it requires a security setup: (for security reasons it wqill only run on a database which has a password setup):
#$ sudo -u postgres psql
# \password
# (enter 'postgres' for the password twice)
# Ctrl-D (to exit psql)
#Then run the link-breaking with:
#$ osm2pgrouting -f data/dcc.osm -d mydatabasename -W postgres
#you also need to do
# $ psql -d mydatabasename
# CREATE EXTENSION pgrouting
#in psql, to enable postgres routing extension.
import psycopg2
import pandas as pd
import geopandas as gpd
import pyproj
import os,re,datetime
from matplotlib.pyplot import *
con = psycopg2.connect(database='mydatabasename', user='root')
cur = con.cursor()
wgs84  = pyproj.Proj(init='epsg:4326')  #WGS84
bng    = pyproj.Proj(init='epsg:27700') #british national grid
def importRoads():     #(data has come from openstreetmap, then ogr2ogr )
    print("importing roads...")
    sql = "DROP TABLE IF EXISTS Road;"
    cur.execute(sql)
    sql = "CREATE TABLE Road (name text, geom geometry, highway text);"
    cur.execute(sql)
    fn_osm_shp = "/headless/data/dcc.osm.shp/lines.shp"
    df_roads = gpd.GeoDataFrame.from_file(fn_osm_shp)
    df_roads = df_roads.to_crs({'init': 'epsg:27700'})
    for index, row in df_roads.iterrows():
        sql="INSERT INTO Road VALUES ('%s', '%s', '%s');"%(row.name, row.geometry, row.highway )
        cur.execute(sql)
    con.commit()    
def importBluetoothSites():
    print("importing sites...")
    sql = "DROP TABLE IF EXISTS BluetoothSite;"
    cur.execute(sql)
    sql = "CREATE TABLE BluetoothSite ( id serial PRIMARY KEY, siteID text, geom geometry);"
    cur.execute(sql)
    con.commit()    
    fn_sites = "/headless/data/dcc/web_bluetooth_sites.csv"
    df_sites = pd.read_csv(fn_sites, header=1)   #dataframe. header is which row to use for the field names.
    for i in range(0, df_sites.shape[0]):      #munging to extract the coordinates - the arrive in National Grid
        locationstr = str(df_sites.iloc[i]['Grid'])
        bng_east  = locationstr[0:6]
        bng_north = locationstr[6:12]
        sql = "INSERT INTO BluetoothSite (siteID, geom) VALUES ('%s', 'POINT(%s %s)');"%(df_sites.iloc[i]['Site ID'], bng_east, bng_north )
        cur.execute(sql)
    con.commit()        
def importDetections():
    print("importing detections...")
    sql = "DROP TABLE IF EXISTS Detection;"
    cur.execute(sql)    
    sql = "CREATE TABLE Detection ( id serial, siteID text, mac text, timestamp timestamp );"
    cur.execute(sql)    
    dir_detections = "/headless/data/dcc/bluetooth/"
    for fn in sorted(os.listdir(dir_detections)):  #import ALL sensor files
        print("processing file: "+fn)
        m = re.match("vdFeb14_(.+).csv", fn)  #use regex to extract the sensor ID
        if m is None:  #if there was no regex match
            continue   #ignore any non detection files
        siteID = m.groups()[0]
        fn_detections = dir_detections+fn
        df_detections = pd.read_csv(fn_detections, header=0)   #dataframe. header is which row to use for the field names.
        for i in range(0, df_detections.shape[0]):   #here we use Python's DateTime library to store times properly
            datetime_text = df_detections.iloc[i]['Unnamed: 0']
            dt = datetime.datetime.strptime(datetime_text ,  "%d/%m/%Y %H:%M:%S" ) #proper Python datetime   
            sql = "INSERT INTO Detection (siteID, timestamp, mac) VALUES ('%s', '%s', '%s');"%(siteID, dt, df_detections.iloc[i]['Number Plate'])
            cur.execute(sql)
    con.commit()    
def plotRoads():   
    print("plotting roads...")
    sql = "SELECT * FROM Road;"
    df_roads = gpd.GeoDataFrame.from_postgis(sql,con,geom_col='geom') #
    for index, row in df_roads.iterrows():
        (xs,ys) = row['geom'].coords.xy
        color='y'
        #road colour by type
        if row['highway']=="motorway":
            color = 'b'
        if row['highway']=="trunk":
            color = 'g'
        #if not color=='y':  #only plot major roads
        plot(xs, ys, color)
def plotBluetoothSites():    
    sql = "SELECT siteID, geom FROM BluetoothSite;"
    df_sites = gpd.GeoDataFrame.from_postgis(sql,con,geom_col='geom') #
    for index, row in df_sites.iterrows():
        (xs,ys) = row['geom'].coords.xy
        plot(xs, ys, 'bo')
def createRoute(con, cur):
    sql = "DROP TABLE IF EXISTS Route;"
    cur.execute(sql)          
    sql="CREATE TABLE Route ( \
            emp_no SERIAL PRIMARY KEY, \
            routeID text, \
            originSiteID text, \
            destSiteID text \
            );"
    cur.execute(sql)          
    con.commit()
def createRouteLink(con, cur):
    sql = "DROP TABLE IF EXISTS routelink;"
    cur.execute(sql)          
    sql="CREATE TABLE routelink ( \
            emp_no SERIAL PRIMARY KEY, \
            routeID text, \
            link_gid bigint \
            );"
    cur.execute(sql)          
    con.commit()
def createRouteCount(con, cur):
    sql = "DROP TABLE IF EXISTS routecount;"
    cur.execute(sql)          
    sql="CREATE TABLE routecount ( \
            emp_no SERIAL PRIMARY KEY, \
            routeID text, \
            timestamp timestamp, \
            winlenseconds integer, \
            count integer \
            );"
    cur.execute(sql)          
    con.commit()
def createLinkCount(con, cur):
    sql = "DROP TABLE IF EXISTS linkcount;"
    cur.execute(sql)          
    sql="CREATE TABLE linkcount ( \
            emp_no SERIAL PRIMARY KEY, \
            gid text, \
            timestamp timestamp, \
            winlenseconds integer, \
            count integer \
            );"
    cur.execute(sql)          
    con.commit()
def makeRoutes(con,cur):
    print("define a route from each sensor to each other")
    sql = "SELECT * FROM BluetoothSite;"
    df_sites = gpd.GeoDataFrame.from_postgis(sql,con,geom_col='geom')
    N = df_sites.shape[0]
    for i_orig in range(0,N):
        for i_dest in range(0,N):
            if (i_orig==i_dest):  #no route from self to self
                continue
            originSiteID = df_sites.iloc[i_orig]['siteid']
            destSiteID = df_sites.iloc[i_dest]['siteid']
            routeID = originSiteID+">"+destSiteID
            sql = "INSERT INTO Route (routeID, originSiteID, destSiteID ) VALUES ('%s', '%s', '%s')"%(routeID, originSiteID, destSiteID)
            print(sql)
            cur.execute(sql)    
    con.commit()
def routeLinks(con,cur): 
    print("computing links on routes")
    sql = "SELECT routeID, ST_X(orig.geom) AS ox, ST_Y(orig.geom) AS oy, ST_X(dest.geom) AS dx, ST_Y(dest.geom) AS dy  FROM Route, BluetoothSite AS orig, BluetoothSite AS dest WHERE originSiteID=orig.siteID AND destSiteID=dest.siteID;"  #join useful data
    df_od = pd.read_sql_query(sql,con)
    N = df_od.shape[0]
    for i in range(0, N):
        routeid=df_od['routeid'][i]
        o_easting  = df_od['ox'].iloc[i]         #link-broken table is stored as latlon so convert on the fly
        o_northing = df_od['oy'].iloc[i]
        d_easting  = df_od['dx'].iloc[i]
        d_northing = df_od['dy'].iloc[i]
        (o_lon,o_lat) = pyproj.transform(bng, wgs84, o_easting, o_northing) #project uses nonISO lonlat convention 
        (d_lon,d_lat) = pyproj.transform(bng, wgs84, d_easting, d_northing) #project uses nonISO lonlat convention 
        #find closest VERTICES to sensors  
        sql = "SELECT id,ST_Distance(ways_vertices_pgr.the_geom,ST_SetSRID(ST_MakePoint(%f, %f),4326)) FROM ways_vertices_pgr ORDER BY st_distance ASC LIMIT 1;"%(o_lon,o_lat)    #4326=SRID code for WGS84
        df_on = pd.read_sql_query(sql,con)
        o_vertex_gid = df_on['id'][0] #get the vertexID of its source
        sql = "SELECT id,ST_Distance(ways_vertices_pgr.the_geom,ST_SetSRID(ST_MakePoint(%f, %f),4326)) FROM ways_vertices_pgr ORDER BY st_distance ASC LIMIT 1;"%(d_lon,d_lat) 
        df_dn = pd.read_sql_query(sql,con)  #dest nearest link
        d_vertex_gid = df_dn['id'][0]   #get vertexID of way target 
        #find (physically) shortest route between them. NB. pgr_dijkstra takes VERTEX ID's not WAY IDs as start and ends.
        sql = "SELECT * FROM pgr_dijkstra('SELECT gid AS id, source, target, length AS cost FROM ways', %d,%d, directed := false), ways  WHERE ways.gid=pgr_dijkstra.edge;"%(o_vertex_gid, d_vertex_gid)
        df_route = gpd.GeoDataFrame.from_postgis(sql,con,geom_col='the_geom')
        #store which links belong to this route
        for i in range(0,df_route.shape[0]):
            rc = df_route.iloc[i]                   #route component
            sql = "INSERT INTO routelink (routeid, link_gid) VALUES ('%s', %s);"%(routeid, rc['gid'])
            print(sql)
            cur.execute(sql)
        con.commit()
def routeCounts(con,cur):   #count number of matching Bluetooth detections between origins and destinations
    sql = "SELECT * FROM Route;"
    df_route = pd.read_sql_query(sql,con)
    for i in range(0, df_route.shape[0]):    #each route
        oSiteID = df_route['originsiteid'][i]
        dSiteID = df_route['destsiteid'][i]
        #MAC matching
        sql = "SELECT d.siteID AS dSiteID,  d.mac as dmac, d.timestamp as dtimestamp  ,   o.siteID AS oSiteID,  o.mac as omac, o.timestamp as otimestamp    FROM Detection AS d, Detection AS o  WHERE d.timestamp>o.timestamp  AND o.mac=d.mac  AND o.siteID='%s' AND d.siteID='%s'"%(oSiteID, dSiteID)
        print(sql)
        df_matches = pd.read_sql_query(sql,con)
        count = df_matches.shape[0]  #count number of bluetooth matches
        #these two variables allow us to compute flows for differnt time windows. Here we just take one whole day.
        winlenseconds = 99999999.9
        timestamp = "2015-02-14 09:00:00"
        sql = "INSERT INTO routecount (routeID, timestamp, winlenseconds, count) VALUES ('%s', '%s', %f, %i)"%(df_route['routeid'].iloc[i], timestamp, winlenseconds, count)
        cur.execute(sql)
        con.commit()
def linkCounts(con, cur):
    sql = "SELECT * FROM RouteCount;"
    df_rc = pd.read_sql_query(sql,con)
    for i in range(0, df_rc.shape[0]):    #each routecount
        row  = df_rc.iloc[i]
        count         = row['count']
        winlenseconds = row['winlenseconds']
        timestamp     = row['timestamp']
        if count>0:
            sql = "SELECT * FROM RouteLink WHERE routeid='%s'"%row['routeid']
            df_rl = pd.read_sql_query(sql,con)
            for j in range(0, df_rl.shape[0]): #add counts for each link
                link = df_rl.iloc[j]                   #route component
                gid_link = link['link_gid']
                sql = "INSERT INTO linkcount (gid, timestamp, winlenseconds, count) VALUES ('%s', '%s', %d, %d);"%(gid_link, timestamp, winlenseconds, count)
                print(sql)
                cur.execute(sql)
            con.commit()
def plotFlows(con,cur):     
    dt_start  = datetime.datetime.strptime('2015-01-05_00:00:00' , "%Y-%m-%d_%H:%M:%S" )
    dt_end    = datetime.datetime.strptime('2016-12-10_00:00:00' , "%Y-%m-%d_%H:%M:%S" )
    sql = "SELECT ways.gid, SUM(linkcount.count), ways.the_geom FROM ways, linkcount  WHERE linkcount.gid::int=ways.gid AND linkcount.timestamp>'%s' AND linkcount.timestamp<'%s'  GROUP BY ways.gid;"%(dt_start,dt_end)
    print(sql) 
    df_links = gpd.GeoDataFrame.from_postgis(sql,con,geom_col='the_geom')
    for i in range(0,df_links.shape[0]): 
        link = df_links.iloc[i]
        lons = link['the_geom'].coords.xy[0] #coordinates in latlon
        lats = link['the_geom'].coords.xy[1]
        gid = int(link.gid) 
        xs=[];ys=[]
        n_segments = len(lons)
        for j in range(0, n_segments):
            (x,y) = pyproj.transform(wgs84, bng, lons[j], lats[j]) #project to BNG -- uses nonISO lonlat convention  #TODO faster to cache this! 
            xs.append(x)
            ys.append(y)
        color='r'
        lw = int(link['sum']/10000)
        plot(xs, ys, color, linewidth=lw)  
importRoads()
importBluetoothSites()
importDetections()
createRoute(con,cur)
makeRoutes(con,cur)
createRouteLink(con,cur)
routeLinks(con,cur)      
createRouteCount(con,cur)
routeCounts(con,cur)
createLinkCount(con,cur)
linkCounts(con,cur)
plotRoads()
plotFlows(con,cur)  
plotBluetoothSites()