# Little Esty Shop
[View Little Esty shop on Heroku](https://polar-atoll-29964-8c4589ba3da8.herokuapp.com/)</br>
[GitHub Repo](https://github.com/lanebret85/little-shop-7)</br>
[Project Board](https://github.com/users/lanebret85/projects/1)</br>
[DTR](https://docs.google.com/document/d/1Ao_JTR4ClvqwTv-wlcmCI6yIlaCO7n6NzTYnFgRrt-8/edit)

## Table of Contents
- [Summary of Work](#summary-of-work)
- [Contributors](#contributors)
- [Ideas for Refactor](#ideas-for-refactor)</br>


<h3 align="center">Project Description</h3>

<p align="center">
  "Little Esty Shop" This project is a web application that serves as a platform for merchants to manage their items and invoices. It also provides admins with tools to monitor merchant performance and handle invoices
</p></br>

## Summary of Work
This project has 6 areas that had to be built out with functionality:
### Merchant Dashboard
We have created a merchant dashboard where a merchant can view their top 5 customers and items that are ready to ship.
### Merchant Items
The Merchant Items features allow visitors to easily interact with a particular merchant's items. These features provide options such as browsing through all of the merchant's items, clicking on individual items to view more details on their dedicated show page, creating new items, enabling or disabling items as needed, and accessing information on the top 5 items for that specific merchant along with their best sale day.
### Merchant Invoices 
When you go to the merchant invoices page you will see a list of all the invoices for a given merchant. Clicking on the invoice will take you to a invoice show page that will display the invoice with associated information. You will also see a table that displays the items on the order and have the option to change the status of that item.
### Admin Dashboard
When I visit the Admin Dashboard, I see links to the Admin Merchants Index page and the Admin Invoices Index page. I also see a list of Incomplete Invoices with the dates they were created organized from earliest to most recent, where each invoice listed has at least one item attached to it that has not yet shipped. Each incomplete invoice # has a link to that invoice's Admin Show page. I also see a list of the Top 5 Customers overall by number of purchases, and I see the number of purchases they've made next to each customer.
### Admin Merchants 
Admin merchants implements an index page that showcases all merchants and allows a user to create a new merchant and a show page for each merchant that shows the name of the specific merchant and an update link to edit that merchant. On the index page there are two sections that show the merchants grouped by their enabled/disabled status, as well as a button to switch that status to enabled or disabled for each merchant. There is also a section that showcases the top 5 merchants based on revenue, as well as the best day of revenue for each merchant.
### Admin Invoices 
Admin Invoices adds an admin invoices index page that showcases all the current invoices with their IDs. Admin Invoices also implements show pages that showcase the invoice id, status, the date it was created at, the total revenue, and the customer associated's first and last name. It also lists out all of the items in that invoice, specifically the item name, quantity, price it sold for, and status. A user can also change the invoice status via a select box on the page.



## Contributors
- [Eliza Keating](https://github.com/elizakeating)
- [Ethan Van Gorkom](https://github.com/EVanGorkom)
- [Lane Bretschneider](https://github.com/lanebret85)
- [Dylan Timmons](https://github.com/DylanScotty)


## Ideas for Refactor
- Making consistent testing data

