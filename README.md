[README.MD](https://github.com/user-attachments/files/32261375/README.MD)
# Olist E-commerce Data Analysis

![Python](https://img.shields.io/badge/Python-Data%20Analysis-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-SQL-blue)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow)
![Pandas](https://img.shields.io/badge/Pandas-EDA-darkblue)

Kompleksowa analiza danych brazylijskiej platformy e-commerce Olist, obejmująca przygotowanie danych w PostgreSQL, analizę eksploracyjną w Pythonie oraz stworzenie dashboardu w Power BI.

Projekt skupia się na sprzedaży, zachowaniach klientów, strukturze geograficznej sprzedaży, popularności kategorii produktowych oraz wpływie terminowości dostaw na oceny klientów.

---

## Cel projektu

Celem projektu było przejście przez pełny proces analizy danych:

**CSV → PostgreSQL → SQL → Python → Power BI**

Projekt odpowiada m.in. na pytania:

- Jak wygląda całkowity poziom sprzedaży?
- Jak zmienia się przychód w czasie?
- Które kategorie produktów generują największy przychód?
- W których regionach sprzedaż jest najwyższa?
- Jak często klienci dokonują kolejnych zakupów?
- Jak terminowość dostawy wpływa na ocenę klienta?
- Jak wygląda rozkład liczby zamówień na klienta?

---

## Technologie

W projekcie wykorzystano:

- **PostgreSQL** – przechowywanie i analiza danych
- **SQL** – JOIN, GROUP BY, CTE, agregacje, walidacja jakości danych
- **Python**
  - pandas
  - SQLAlchemy
  - matplotlib
- **Jupyter Notebook / VS Code** – analiza eksploracyjna
- **Power BI** – dashboard i wizualizacja wyników
- **Excel** – warstwa pośrednia do Power BI
- **Git / GitHub** – wersjonowanie projektu

---

## Źródło danych

Projekt wykorzystuje publiczny zbiór:

**Brazilian E-Commerce Public Dataset by Olist**

Dane obejmują informacje o:

- zamówieniach
- klientach
- produktach
- sprzedawcach
- pozycjach zamówień
- płatnościach
- recenzjach
- lokalizacji
- kategoriach produktowych

W bazie wykorzystano tabele:

- `orders`
- `customers`
- `order_items`
- `order_payments`
- `order_reviews`
- `products`
- `sellers`
- `geolocation`
- `category_translation`

---

## Proces analizy

### 1. Import danych

Pliki CSV zostały zaimportowane do PostgreSQL.

Po imporcie sprawdzono:

- liczbę rekordów
- unikalność identyfikatorów
- brakujące wartości
- poprawność relacji pomiędzy tabelami
- potencjalne duplikaty
- anomalie dat

---

### 2. Kontrola jakości danych

Analiza jakości danych obejmowała m.in.:

- brakujące daty zatwierdzenia zamówień
- brakujące daty dostawy
- brakujące kategorie produktów
- brakujące dane dotyczące wymiarów produktów
- niepoprawne wartości cen i kosztów dostawy
- brakujące relacje między tabelami
- potencjalne anomalie w kolejności etapów realizacji zamówienia

W trakcie analizy wykryto również problem z wieloma rekordami recenzji przypisanymi do jednego zamówienia.

Bezpośredni JOIN pomiędzy `order_reviews` i `order_items` powodował powielanie części rekordów i zawyżenie przychodu.

Problem został rozwiązany poprzez agregację recenzji do poziomu `order_id` przed wykonaniem JOIN-a.

---

## Najważniejsze KPI

Dla zamówień o statusie `delivered`:

- **Przychód:** 13 221 498,11
- **Liczba zamówień:** 96 478
- **Liczba klientów:** 93 358
- **Średnia wartość zamówienia:** 137,04

---

## Najważniejsze wnioski biznesowe

### Sprzedaż jest skoncentrowana w kilku kategoriach

Największy przychód generują m.in.:

- `health_beauty`
- `watches_gifts`
- `bed_bath_table`
- `sports_leisure`
- `computers_accessories`

Może to wskazywać na istotne znaczenie kilku kluczowych segmentów produktowych dla całkowitej sprzedaży.

---

### São Paulo generuje największą sprzedaż

Stan **SP – São Paulo** odpowiada za największą część przychodu oraz liczby zamówień.

Sprzedaż jest więc wyraźnie skoncentrowana geograficznie.

---

### Retencja klientów jest niska

Zdecydowana większość klientów dokonała tylko jednego zakupu.

Rozkład liczby zamówień:

- 1 zamówienie – 90 557 klientów
- 2 zamówienia – 2 573 klientów
- 3 zamówienia – 181 klientów
- 4 zamówienia – 28 klientów

Udział klientów dokonujących więcej niż jednego zakupu wynosi około **3%**.

Jest to jeden z najważniejszych obszarów biznesowych wymagających poprawy.

---

### Terminowość dostaw wpływa na oceny klientów

Średnia ocena zamówień:

- **dostarczonych na czas lub wcześniej:** 4,29
- **dostarczonych z opóźnieniem:** 2,57

Różnica jest wyraźna i wskazuje, że jakość procesu logistycznego ma istotny wpływ na poziom satysfakcji klientów.

---

## Dashboard Power BI

Dashboard przedstawia najważniejsze wyniki analizy:

- przychód
- liczbę zamówień
- liczbę klientów
- średnią wartość zamówienia
- miesięczny przychód
- przychód według kategorii
- przychód według stanu klienta
- liczbę zamówień według stanu
- rozkład liczby zamówień na klienta
- porównanie ocen dla dostaw terminowych i opóźnionych

### Podgląd dashboardu

![Dashboard Power BI](IMAGES/dashboard.png)

---

## Struktura projektu

```text
Analiza/
│
├── DATA/
│   └── pliki źródłowe CSV
│
├── SQL/
│   └── zapytania SQL
│
├── NOTEBOOKS/
│   └── 01_eda.ipynb
│
├── DASHBOARD/
│   └── olist_powerbi_data.xlsx
│
├── IMAGES/
│   └── dashboard.png
│
└── README.md
