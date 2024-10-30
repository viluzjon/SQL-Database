# Tourist Guide Database

This project is a database management system for a tourist guide service. It handles ticket sales, group assignments for tourists, guide availability, and tour details. The system also provides views for analyzing sales and tracking guide assignments.

## Database Schema

The database consists of the following tables:

- **Klienci**: Information about customers.
- **Przewodnicy**: Information about guides.
- **Przewoźnicy**: Information about transport providers.
- **Regiony**: Information about regions.
- **SzczegolyZakupu**: Details of ticket purchases.
- **TrudnoscTrasy**: Difficulty levels of the tours.
- **Wycieczki**: Information about the tours.

### Views

The following views are included:

- **KlienciWycieczki**: Shows customers and their purchased tours with details.
- **MiesiecznaSprzedaz**: Displays monthly sales and revenue.
- **PrzewodnicyBezWycieczek**: Lists guides not assigned to any tours.

### Functions

The following functions are implemented:

- **F_CenaWycieczki**: Returns the price of a tour based on the provided ID.
- **F_WolniPrzewodnicy**: Returns the availability of guides within a specified time range.
- **F_GrupaPrzewodnika**: Groups tourists assigned to a specific guide.
- **F_WycieczkaPrzewodnika**: Displays guides and their tours.

### Procedures

The following procedure is defined:

- **Proc_TrudnoscTrasy**: Displays tours based on the specified difficulty level and their prices.

### Triggers

- **TR_SzczegolyZakupu_Wycieczki_AFTER_INSERT**: Updates the count of available and booked seats for a tour upon inserting rows into the SzczegolyZakupu table. It also prevents overbooking of seats.

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/tourist-guide-database.git
