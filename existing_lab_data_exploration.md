-   [Introduction](#introduction)
-   [Nigeria](#nigeria)
    -   [Equipment Info](#equipment-info)
    -   [Facility Info](#facility-info)
    -   [Combining Facility Info to Equipment
        Info](#combining-facility-info-to-equipment-info)
    -   [Description of Deficiencies](#description-of-deficiencies)
    -   [Conclusions and
        Recommendations](#conclusions-and-recommendations)
-   [Cameroon](#cameroon)

Introduction
============

During initial discussions regarding the eTool development a list of
equipment characteristics was agreed upon. In this report I describe the
presence or absence of these characteristics in the in-country data
already collected in Nigeria and Cameroon during past laboratory
assessments.

If the characteristic is present in existing data, I describe in this
report the completeness of this characteristic among equipment
inventoried during the past assessment and any other associated issues
with the data.

Nigeria
=======

The Nigerian assessment Dropbox folder was shared with me and contained
assessment data last revised March 8th, 2013. 697 facilities were
included in these data. Not every facility was fully evaluated as safety
concerns were cited as a barrier to assessment.

The two main files I obtained data from were westat\_origDB 1 (Facility
Information) and westat\_origDB2 (Equipment Information), both are 2007
Access Databases (DB henceforth). My general approach was to pull
relevant information from these databases and combine them to form a
final data set that most closely resembles the data set I would need for
the eTool where each row would be an individual piece of laboratory
equipment, and each column a different characteristic describing that
piece of equipment.

In other sections of this report I describe my process in further
detail, below is the list of equipment characteristics deemed as
necessary for the eTool by the IT Task Force. Next to each item I
describe whether the characteristic was present in the Facility
Information DB, Equipment Information DB, or absent.

-   Type of equipment (Equipment Information)
-   Manufacturer (Equipment Information)
-   Date of manufacture (Equipment Information)
-   Serial number (Equipment Information)
-   Date equipment became active at the facility (absent)
-   Date equipment no longer viable (absent)
-   Equipment location – facility name (Facility Information)
-   Equipment location – GPS coordinates (geocoded from facility
    address)
-   Ownership type (Government, private owned, etc) (Facility
    Information)
-   Level of health facility (e.g Referral lab, province lab) (Facility
    Information)
-   Name of engineer performing most recent calibration (absent)
-   Post of engineer performing most recent calibration (Equipment
    Information)
-   Most recent calibration date (absent)
-   Next calibration date (absent)
-   Most recent maintenance date (absent)
-   Name of engineer performing most recent maintenance (absent - only
    maintenance organization included)
-   Post of engineer performing most recent maintenance (Equipment
    Information)
-   Next maintenance date (absent)
-   Equipment retirement flag (not applicable to initial data)
-   Retirement request date (not applicable to initial data)

Equipment Info
--------------

The Equipment Info DB contained an inventory of equipment information
collected during the assessment. Essentially, each table contained
information related to a specific equipment type (tables used listed
below) for each of the 697 facilities evaluated. Structuring the data in
this manner is problematic as a single facility could have more than one
of a certain type of equipment (or none). For example, a single lab
could have reported having 3 safety cabinets, but in the data only one
serial number at most was listed. Thus a full inventory of all equipment
was not available in these data.

-   Auto Cell Sorter
-   Autoclave
-   Bio Safety Cab
-   CD4 Analyzer
-   Centrifuge
-   Chemical Fume Hood
-   Clean Bench
-   Gene Analyzer
-   Hematology Analyzer
-   Incinerator
-   Incubator
-   Water Distiller

Although the tables in the Equipment DB contain different information
depending on the equipment described, I was able to obtain all
characteristics listed under the Introduction section listed with
“Equipment Information” next to the characteristic. I left out all data
in the Equipment DB where the facility did not respond that they had the
equipment being described.

Facility Info
-------------

The Facility Info DB contained information describing a different
characteristic of laboratories evaluated (financial, equipment
maintenance, etc). I was able to obtain all characteristics listed in
the Introduction section from the lab\_profile table.

Laboratory GPS coordinates were not included in these data, laboratory
address was included for most. I geocoded these addresses using the
MapQuest API (see the [Final
Report](https://paceafenet.github.io/final_report/) for full details).
These addresses were of limited utility as many addresses were informal
(e.g. off 107 S highway) or were simply the state the lab was located
in. I assumed all addresses were in Nigeria. The geocoding API I used
attempts to locate the address provided at the most granular level
possible (actual address). If the address cannot be located then the
geocoder will return the center point of the state (if identified), if
neither the address nor state can be identified then the center point of
Nigeria was returned.

Combining Facility Info to Equipment Info
-----------------------------------------

A unique facility ID was assigned to each lab as well as the equipment
described. I joined the equipment information to the facility
information.

Description of Deficiencies
---------------------------

The most notable deficiency with the equipment data is that it is not a
complete inventory of each piece of equipment at each facility.

In the table below we see that for 8,136 equipment items there was
nothing listed for equipment count even though a serial number may still
have been listed for some of these. Next, and most important to note, 2,
3, 4, or 6 was listed for 1,943 rows in the Equipment DB, but at most
one serial number was listed for equipment.

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>
Frequency of Responses: Equipment Count
</caption>
<thead>
<tr>
<th style="text-align:left;">
Equipment Count Response
</th>
<th style="text-align:right;">
Count
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
1
</td>
<td style="text-align:right;">
5451
</td>
</tr>
<tr>
<td style="text-align:left;">
2
</td>
<td style="text-align:right;">
1480
</td>
</tr>
<tr>
<td style="text-align:left;">
3
</td>
<td style="text-align:right;">
352
</td>
</tr>
<tr>
<td style="text-align:left;">
4
</td>
<td style="text-align:right;">
64
</td>
</tr>
<tr>
<td style="text-align:left;">
6
</td>
<td style="text-align:right;">
47
</td>
</tr>
<tr>
<td style="text-align:left;">
NA
</td>
<td style="text-align:right;">
8136
</td>
</tr>
<tr>
<td style="text-align:left;">
Total
</td>
<td style="text-align:right;">
15530
</td>
</tr>
</tbody>
</table>
Next, in the table below it is clear that equipment information
including serial number, model number, service provider, and
manufacturer were most frequently missing in these data. Recall that
rows from the Equipment DB were only used where the equipment was
denoted as present at the facility, thus the information in the table
describes how often the characteristic was missing from the data where
the equipment was present at the facility.

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>
Description of Lab Equipment Characteristics
</caption>
<thead>
<tr>
<th style="text-align:left;">
Equipment Feature
</th>
<th style="text-align:right;">
Missing
</th>
<th style="text-align:right;">
Not Missing
</th>
<th style="text-align:right;">
Total
</th>
<th style="text-align:left;">
Percent Missing
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Service Provider
</td>
<td style="text-align:right;">
13548
</td>
<td style="text-align:right;">
1982
</td>
<td style="text-align:right;">
15530
</td>
<td style="text-align:left;">
87.24%
</td>
</tr>
<tr>
<td style="text-align:left;">
Manufacture Date
</td>
<td style="text-align:right;">
13425
</td>
<td style="text-align:right;">
2105
</td>
<td style="text-align:right;">
15530
</td>
<td style="text-align:left;">
86.45%
</td>
</tr>
<tr>
<td style="text-align:left;">
Serial Number
</td>
<td style="text-align:right;">
11151
</td>
<td style="text-align:right;">
4379
</td>
<td style="text-align:right;">
15530
</td>
<td style="text-align:left;">
71.8%
</td>
</tr>
<tr>
<td style="text-align:left;">
Model Number
</td>
<td style="text-align:right;">
8810
</td>
<td style="text-align:right;">
6720
</td>
<td style="text-align:right;">
15530
</td>
<td style="text-align:left;">
56.73%
</td>
</tr>
<tr>
<td style="text-align:left;">
Equipment Count
</td>
<td style="text-align:right;">
8136
</td>
<td style="text-align:right;">
7394
</td>
<td style="text-align:right;">
15530
</td>
<td style="text-align:left;">
52.39%
</td>
</tr>
<tr>
<td style="text-align:left;">
Manufacturer
</td>
<td style="text-align:right;">
6481
</td>
<td style="text-align:right;">
9049
</td>
<td style="text-align:right;">
15530
</td>
<td style="text-align:left;">
41.73%
</td>
</tr>
<tr>
<td style="text-align:left;">
Laboratory Affiliation
</td>
<td style="text-align:right;">
3336
</td>
<td style="text-align:right;">
12194
</td>
<td style="text-align:right;">
15530
</td>
<td style="text-align:left;">
21.48%
</td>
</tr>
<tr>
<td style="text-align:left;">
Laboratory Level
</td>
<td style="text-align:right;">
3283
</td>
<td style="text-align:right;">
12247
</td>
<td style="text-align:right;">
15530
</td>
<td style="text-align:left;">
21.14%
</td>
</tr>
<tr>
<td style="text-align:left;">
Laboratory Address
</td>
<td style="text-align:right;">
2042
</td>
<td style="text-align:right;">
13488
</td>
<td style="text-align:right;">
15530
</td>
<td style="text-align:left;">
13.15%
</td>
</tr>
<tr>
<td style="text-align:left;">
Laboratory Name
</td>
<td style="text-align:right;">
32
</td>
<td style="text-align:right;">
15498
</td>
<td style="text-align:right;">
15530
</td>
<td style="text-align:left;">
0.21%
</td>
</tr>
<tr>
<td style="text-align:left;">
Equipment Type
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
15530
</td>
<td style="text-align:right;">
15530
</td>
<td style="text-align:left;">
0%
</td>
</tr>
</tbody>
</table>
Conclusions and Recommendations
-------------------------------

1.  For more accurate location of lab equipment we would will need
    latitude and longitudes of labs, or at least more descriptive
    addresses.
2.  These data can be used for demonstration as they are now, but the
    eTool will be most useful with a complete inventory of equipment at
    each lab.
3.  Information initially identified as essential including calibration
    dates which could be used to identify when equipment is due for
    maintenance, calibration, or retirement is largely dependent on
    manufacturer specifications. From the data as it is currently, it
    would not be possible to identify when equipment should next be
    serviced. This point will require further discussion.

Cameroon
========
