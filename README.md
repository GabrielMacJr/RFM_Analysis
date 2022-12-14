# RFM Analysis with TSQL

<p align = "center">
<img width = 650px height = 450px src = "https://user-images.githubusercontent.com/110753469/208200867-0d9ef64a-043a-4dce-9af6-d3898227aac2.png">
</p>

# Objective
Use TSQL to perform RFM segmentation analysis on sales data.

# What is RFM Analysis?

<ul>
  <li> RFM analysis is a marketing technique used to rank and group customers based on the <b>recency</b>, <b>frequency</b> and <b>monetary value</b> of their recent transactions to identify the best customers and perform targeted marketing campaigns.</li>
    
  <li>The RFM model may assigns a rank of 1 through 5 (from worst to best) for customers in each of the three categories: <b>Recency</b>, <b>Frequency</b>, <b>Monetary Value</b>. The ideal customer would therefore have a score of 555. The higher the customer ranking, the more likely it is that they will do business again with a firm. <i>*RFM analysis models may assign different values when ranking, it does not have to be the 1 through 5 ranking system.*</i></li>
  
  <li>RFM analysis helps firms reasonably predict which customers are likely to purchase their products again, how much revenue comes from new (versus repeat) clients, and how to turn occasional buyers into habitual ones. Furthremore, RFM analysis is used to identify a company's or an organization's best customers by measuring and analyzing spending habits in order to improve low-scoring customers and maintain high-scoring ones.
  </li>
</ul>

<ol>
<li><b>Recency</b>: How recently a customer has made a purchase.<br>The more recently a customer has made a purchase with a company, the more likely they will continue  purchasing from that company.</br></li>
<li><b>Frequency</b>: How often a customer makes a purchase.<br>If the purchase cycle can be predicted, for example when a customer needs to buy more groceries, then marketing efforts may be directed towards reminding them to visit the business when staple items run low.</br></li>
<li><b>Monetary Value</b>: How much money a customer spends on purchases. <br>Customers who spend a lot of money are more likely to spend money in the future and have a high value to a business.</br></li>
</ol>

<h6><i>*NTILE(5) function is used to group the data into 5 groups. K-means, hierarchical clustering, Gaussian, Spectral Clustering were not used to group data.*</i></h6>


# RFM Analysis Code: [Click Here](https://github.com/GabrielMacJr/RFM_Analysis/blob/master/RFMSQLQuery.sql)
<h6>This is a preview of the RFM segmentation code. Click link above to see the complete TSQL code</h6>

![RFManalysis](https://user-images.githubusercontent.com/110753469/199351827-affb5f57-d1cb-423f-b38a-cd134bf5f10e.PNG)

# RFM Segmentation Results: [Click Here](https://github.com/GabrielMacJr/RFM_Analysis/blob/master/RFM%20Analysis%20Segmentation%20Results.txt)
 <h6>This is a preview of the RFM segmentation results. Click link above to see the complete results </h6>

![rfm results table](https://user-images.githubusercontent.com/110753469/208203093-f0ae508d-9abb-41be-b2cc-e8f9c97cd3d9.PNG)
