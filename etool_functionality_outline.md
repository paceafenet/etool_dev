---
title: "eTool Functionality Outline"
description: |
 This report outlines the functionality of the eTool along with considerations for future use of the underlying data
author:
  - name: Travis Sondgerath
date: '2019-02-16'
output:
  md_document:
    toc: true
    toc_depth: 2
    preserve_yaml: true
always_allow_html: no

# Export as pdf as well

# output:
#   pagedown::html_paged:
#     toc: true
#     self_contained: true
# toc-title: Contents
---

-   [Introduction](#introduction)
-   [User Interface and Visual
    Layout](#user-interface-and-visual-layout)
-   [Data Update](#data-update)
-   [End Uses](#end-uses)
-   [Conclusions](#conclusions)

Introduction
============

The purpose of the eTool is primarily to help maintenance personnel, lab
supervisors, and other interested stakeholders use the tool in the
following ways;

-   Identify labs that have equipment in need of attention
-   Identify specific pieces of equipment in need of attention
-   Differentiate between actions that need to be taken immediately and
    those that need to be taken soon
-   Update the status of individual equipment and their underlying data
-   Track when and by whom maintenance activities were performed

Lab equipment is critical to supporting HIV-related activities in
PEPFAR-supported countries. In order to provide quality laboratory
services it is important to know what equipment is present in supported
laboratories, if it is functional, and when maintenance activities were
performed.

This effort was taken in part to identify what features would be
necessary to develop an eTool with the functionality described above and
also to describe what data would be necessary to create such a tool. In
conjunction with the partner organizations involved in the pan-African
Consortium, we developed a list of desired features for the eTool.
Additionally, we outlined what equipment data would be necessary for the
tool to function as desired..

Existing data held by partner organizations was found to be lacking many
key elements. See the [full
report](https://github.com/paceafenet/etool_dev/blob/master/existing_lab_data_exploration.md).
Additionally, equipment data held by the maintenance partner was also
found to be lacking. Resources required to collect necessary data would
have caused substantial delay beyond the contracted project period.
Therefore, the eTool outlined in this report was developed using dummy
data and is for demonstration purposes. However, it is not unreasonable
to believe that such data could be procured given enough time and human
resources using data collection tools already available to partner
organizations.

User Interface and Visual Layout
================================

![Current eTool
Layout](screen%20grabs/eTool%20pic%20full%20layout%202_15_19.jpg)

The current eTool layout is meant to be informative and functional.

Displayed prominently in the center of the tool by default is a map
zoomed to the extent of all selected laboratories (all labs with
equipment requiring immediate attention by default). A red circle
indicates that the facility highlighted has **at least** one piece of
equipment that requires immediate attention (maintenance, calibration
past due or equipment no longer viable). Circles highlighted in yellow
if attention required within 10 days (could set to any time period). The
user can click or hover over any circle within the map to see which lab
is highlighted.

In addition to the map, a second tab is included in the same window as
the map which is currently named “edit data.” This table shows
equipment-specific data including the facility name, equipment ID as
well as critical dates for service dates and assumed next service dates
depending on current service dates. The background color in each cell
corresponds to the same color scheme as described above for the
laboratories.

The map and table are each responsive to the first two check box groups
shown on the left. By default, the eTool displays data in the map and
table only for equipment that requires immediate attention. It is also
possible to filter to equipment requiring attention within 10 days or to
those not requiring attention (labeled as ‘OK’).

At the bottom of the eTool there are three tabs; ‘By Attention
Category,’ ‘By Facility,’ and ‘By Lab Level.’ Each of these are bar
graphs. By Attention Category describes the number of pieces of
equipment within each attention category, bar colors correspond to the
color schemes outlined above. By Facility describes the number equipment
requiring immediate attention by facility (Lab, Lab1, Lab2, Lab3, Lab4
used for demonstration purposes), and Lab Level (district, regional,
national, other as reasonable assumptions of levels that would be
present in real data). Additionally, there is a scroll bar on the far
right of each bar graph, scrolling down reveals a table summarizing the
data in the graphs. These three graphs are **not** responsive to the
check box filters on the left side of the tool (but could be).

Data Update
===========

On the left side of the tool there is also one text box, one drop down
selector, one date input, and two buttons. Based on the results shown in
the map and table, the user could decide to take action and update the
status of equipment described. The eTool was designed to address two
scenarios;

1.  Calibration dates do not reflect present status

-   Refer to ‘Edit Table,’ find the equipment ID for the equipment that
    needs to be edited
-   Select either ‘Most Recent Calibration’ or ‘Most Recent Maintenance’
    from the ‘Select a Date’ dropdown
-   Select a date in ‘Select a new date’
-   Click the ‘Alter Date’ button. A message will appear notifying you a
    change has been made to the data. If you have clicked this button in
    error or need to enter a different date, change your selections and
    click the button again.

1.  Equipment has been taken out of service

-   The tool may reflect that equipment requires maintenance, however,
    it may be that the equipment has already been or will soon be
    retired.
-   Refer to ‘Edit Table,’ find the equipment ID for the equipment that
    needs to be edited, enter the ID in the text box
-   Click the ‘Submit Retirement Request’ button
-   if this button was selected in error the administrator will need to
    be contacted to alter the underlying data

In order to view the results of **either** of the changes described
above in the eTool you will need to close the browser window the eTool
is being viewed in and re-open the eTool.

End Uses
========

A limited amount of data is shown in the eTool. The goal of the eTool is
to provide a high level summary of the data in its current state as well
as the ability to identify equipment requiring attention and alter their
data where appropriate.

In addition to the functionality described above, the eTool was designed
to preserve *all* equipment data. Thus each time a user alters the
underlying data, the ‘new’ equipment data state is added to the previous
data. Thus if five changes were made to the same piece of equipment
using the eTool, then there would be five rows of data for that
equipment in the underlying dataset (only the most recent would be
reflected in the eTool).

This would allow for the creation of a ‘life book’ for individual pieces
of equipment. By preserving all data for each piece of equipment it
would be clear when and how often equipment were interacted with.
Additionally, it would be clear when equipment was put in service, when
it was taken out of service, and when it was maintained or calibrated.

In addition to maintenance dates, the underlying data describes each
piece of equipment in detail including the laboratory name, level,
location, maintenance contractor, equipment type, etc. This information
was excluded from the eTool as it fell outside of the desired scope of
the eTool functionality. However, this additional information, when
coupled with the fact that historical data is preserved when equipment
data is updated using the eTool means there is a great deal of
information that can be used in analyses outside the eTool.

The table below shows the equipment features desired by the Equipment
Maintenance Team. These features are contained in the demonstration data
used to develop the current version of the eTool.

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#hswndleimv .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #000000;
  font-size: 16px;
  background-color: #FFFFFF;
  /* table.background.color */
  width: auto;
  /* table.width */
  border-top-style: solid;
  /* table.border.top.style */
  border-top-width: 2px;
  /* table.border.top.width */
  border-top-color: #A8A8A8;
  /* table.border.top.color */
}

#hswndleimv .gt_heading {
  background-color: #FFFFFF;
  /* heading.background.color */
  border-bottom-color: #FFFFFF;
}

#hswndleimv .gt_title {
  color: #000000;
  font-size: 125%;
  /* heading.title.font.size */
  padding-top: 4px;
  /* heading.top.padding */
  padding-bottom: 1px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#hswndleimv .gt_subtitle {
  color: #000000;
  font-size: 85%;
  /* heading.subtitle.font.size */
  padding-top: 1px;
  padding-bottom: 4px;
  /* heading.bottom.padding */
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#hswndleimv .gt_bottom_border {
  border-bottom-style: solid;
  /* heading.border.bottom.style */
  border-bottom-width: 2px;
  /* heading.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* heading.border.bottom.color */
}

#hswndleimv .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  padding-top: 4px;
  padding-bottom: 4px;
}

#hswndleimv .gt_col_heading {
  color: #000000;
  background-color: #FFFFFF;
  /* column_labels.background.color */
  font-size: 16px;
  /* column_labels.font.size */
  font-weight: initial;
  /* column_labels.font.weight */
  vertical-align: middle;
  padding: 10px;
  margin: 10px;
}

#hswndleimv .gt_sep_right {
  border-right: 5px solid #FFFFFF;
}

#hswndleimv .gt_group_heading {
  padding: 8px;
  color: #000000;
  background-color: #FFFFFF;
  /* stub_group.background.color */
  font-size: 16px;
  /* stub_group.font.size */
  font-weight: initial;
  /* stub_group.font.weight */
  border-top-style: solid;
  /* stub_group.border.top.style */
  border-top-width: 2px;
  /* stub_group.border.top.width */
  border-top-color: #A8A8A8;
  /* stub_group.border.top.color */
  border-bottom-style: solid;
  /* stub_group.border.bottom.style */
  border-bottom-width: 2px;
  /* stub_group.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* stub_group.border.bottom.color */
  vertical-align: middle;
}

#hswndleimv .gt_empty_group_heading {
  padding: 0.5px;
  color: #000000;
  background-color: #FFFFFF;
  /* stub_group.background.color */
  font-size: 16px;
  /* stub_group.font.size */
  font-weight: initial;
  /* stub_group.font.weight */
  border-top-style: solid;
  /* stub_group.border.top.style */
  border-top-width: 2px;
  /* stub_group.border.top.width */
  border-top-color: #A8A8A8;
  /* stub_group.border.top.color */
  border-bottom-style: solid;
  /* stub_group.border.bottom.style */
  border-bottom-width: 2px;
  /* stub_group.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* stub_group.border.bottom.color */
  vertical-align: middle;
}

#hswndleimv .gt_striped {
  background-color: #f2f2f2;
}

#hswndleimv .gt_row {
  padding: 10px;
  /* row.padding */
  margin: 10px;
  vertical-align: middle;
}

#hswndleimv .gt_stub {
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #A8A8A8;
  padding-left: 12px;
}

#hswndleimv .gt_stub.gt_row {
  background-color: #FFFFFF;
}

#hswndleimv .gt_summary_row {
  background-color: #FFFFFF;
  /* summary_row.background.color */
  padding: 6px;
  /* summary_row.padding */
  text-transform: inherit;
  /* summary_row.text_transform */
}

#hswndleimv .gt_first_summary_row {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
}

#hswndleimv .gt_table_body {
  border-top-style: solid;
  /* field.border.top.style */
  border-top-width: 2px;
  /* field.border.top.width */
  border-top-color: #A8A8A8;
  /* field.border.top.color */
  border-bottom-style: solid;
  /* field.border.bottom.style */
  border-bottom-width: 2px;
  /* field.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* field.border.bottom.color */
}

#hswndleimv .gt_footnote {
  font-size: 90%;
  /* footnote.font.size */
  padding: 4px;
  /* footnote.padding */
}

#hswndleimv .gt_sourcenote {
  font-size: 90%;
  /* sourcenote.font.size */
  padding: 4px;
  /* sourcenote.padding */
}

#hswndleimv .gt_center {
  text-align: center;
}

#hswndleimv .gt_left {
  text-align: left;
}

#hswndleimv .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#hswndleimv .gt_font_normal {
  font-weight: normal;
}

#hswndleimv .gt_font_bold {
  font-weight: bold;
}

#hswndleimv .gt_font_italic {
  font-style: italic;
}

#hswndleimv .gt_super {
  font-size: 65%;
}

#hswndleimv .gt_footnote_glyph {
  font-style: italic;
  font-size: 65%;
}
</style>
<!--gt table start-->
<table class="gt_table">
<thead>
<tr>
<th colspan="1" class="gt_heading gt_title gt_font_normal gt_center">
Table 1
</th>
</tr>
<tr>
<th colspan="1" class="gt_heading gt_subtitle gt_font_normal gt_center gt_bottom_border">
</th>
</tr>
</thead>
<tr>
<th class="gt_col_heading gt_left" rowspan="1" colspan="1">
Column Names: Fake Data
</th>
</tr>
<tbody class="gt_table_body">
<tr>
<td class="gt_row gt_left">
serial\_num
</td>
</tr>
<tr>
<td class="gt_row gt_left gt_striped">
equip\_type
</td>
</tr>
<tr>
<td class="gt_row gt_left">
manufacturer
</td>
</tr>
<tr>
<td class="gt_row gt_left gt_striped">
manufacture\_date
</td>
</tr>
<tr>
<td class="gt_row gt_left">
date\_active
</td>
</tr>
<tr>
<td class="gt_row gt_left gt_striped">
date\_not\_viable
</td>
</tr>
<tr>
<td class="gt_row gt_left">
facility
</td>
</tr>
<tr>
<td class="gt_row gt_left gt_striped">
ownership\_type
</td>
</tr>
<tr>
<td class="gt_row gt_left">
lab\_level
</td>
</tr>
<tr>
<td class="gt_row gt_left gt_striped">
calib\_engineer\_nm
</td>
</tr>
<tr>
<td class="gt_row gt_left">
calib\_engineer\_post
</td>
</tr>
<tr>
<td class="gt_row gt_left gt_striped">
most\_recent\_calibration
</td>
</tr>
<tr>
<td class="gt_row gt_left">
next\_calibration
</td>
</tr>
<tr>
<td class="gt_row gt_left gt_striped">
most\_recent\_maintenance
</td>
</tr>
<tr>
<td class="gt_row gt_left">
next\_maintenance
</td>
</tr>
<tr>
<td class="gt_row gt_left gt_striped">
maintenance\_engineer\_nm
</td>
</tr>
<tr>
<td class="gt_row gt_left">
maintenance\_engineer\_post
</td>
</tr>
<tr>
<td class="gt_row gt_left gt_striped">
retirement\_date
</td>
</tr>
<tr>
<td class="gt_row gt_left">
retirement\_requested
</td>
</tr>
<tr>
<td class="gt_row gt_left gt_striped">
retirement\_dt\_requested
</td>
</tr>
<tr>
<td class="gt_row gt_left">
long
</td>
</tr>
<tr>
<td class="gt_row gt_left gt_striped">
lat
</td>
</tr>
<tr>
<td class="gt_row gt_left">
last\_altered
</td>
</tr>
</tbody>
</table>
<!--gt table end-->

<!--/html_preserve-->
Conclusions
===========

All functionality desired by the Equipment Maintenance Team is present
in the current version of the eTool. However, minor aesthetic changes
may be desirable before finalizing. The eTool is designed to be
interactive. Users can alter the underlying data behind the eTool,
additionally, all historical equipment data is preserved allowing for
multiple uses of the data outside of the eTool’s core functionality.
