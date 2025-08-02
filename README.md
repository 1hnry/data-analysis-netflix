# Netflix Content Strategy Analysis 📊

This project presents a business intelligence case study based on the Netflix catalog. Using a public dataset from Kaggle, the goal here was to go beyond surface-level metrics and discover how Netflix shapes its content catalog - and, more importantly, why.

![Project Status](https://img.shields.io/badge/status-completed-green)

---

## ❓ Key Business Questions
This analysis was guided by the following questions:
* How has the Netflix catalog evolved over time?
* Does Netflix apply a single model across content types, or does it use different strategies for movies and series?
* How global is the Netflix catalog, and what roles do different countries play in its content production?

## 🛠️ Tools and Libraries Used
* **Language:** R
* **Packages:** `tidyverse`, `lubridate`, `patchwork`, `showtext`, `ggthemes`

---

## 📊 Key Insights & Visualizations
### 1. Predictable Movies, Disposable Series? A Dual Content Strategy
When comparing content durations, a very clear divide emerges in how Netflix treats movies versus series.

**🎬 For Movies, Predictability is Key**

Most Netflix films fall within the classic 85–120 minute window — a sweet spot audiences are already used to. It’s a predictable format, and that’s probably the point. Netflix isn’t pushing boundaries with movie runtimes; it’s sticking to what works. The strategy here feels low-risk, focused on delivering a familiar experience rather than experimentation.

**📺 For TV Shows: One Season to Prove Yourself**

TV Shows, on the other hand, tell a different story. The bar chart makes it obvious: titles with just one season completely dominate. This supports the popular belief that Netflix cancels quickly — and the data backs that up. But instead of seeing it as a flaw, it might be more accurate to say Netflix treats each new series like a startup. Most won’t survive past season one unless they show real traction. It's a high-volume, market-testing approach that prioritizes scalability over long-term bets.

![Dashboard](Netflix%20Project/images/dashboard-final.png)

---

### 2. The Hypergrowth Era: Rapid Expansion, Then a Strategic Shift

The monthly timeline of content additions tells the story of Netflix’s hypergrowth phase — a period between 2018 and 2020 when the platform was scaling its library at breakneck speed. Month after month, hundreds of new titles were added as Netflix raced to cement its leadership in the streaming space.

But around early 2021, the data shows a clear slowdown. This shift likely reflects a mix of factors: the lagging effects of the COVID-19 pandemic on production, rising content costs, and a strategic pivot toward more selective, profit-driven growth. Instead of focusing purely on volume, Netflix seems to be entering a new phase of consolidation — refining its catalog with a more curated, sustainable approach.

![Monthly](Netflix%20Project/images/monthly-additions.png)

---

### 3. The Globalization Paradox: A US Core with a Global Face

At first glance, Netflix’s library appears heavily US-centered — and in terms of raw production volume, that’s true. But a closer look reveals a much more global strategy in action.

The heatmap highlights key international content hubs that play distinct roles in Netflix’s ecosystem. Japan leads in Anime, South Korea dominates serialized dramas, and India stands out as a major contributor — particularly in films and regional storytelling. The influence of Bollywood, with its rich cinematic tradition and massive local audience, is clearly reflected in the volume and genre diversity of Indian content on the platform.

India’s content not only caters to domestic viewers but is also increasingly positioned for international audiences, especially within the “International Movies” category — one of the most frequently used genre tags. This suggests that Netflix isn't just localizing content, but strategically elevating regional industries to serve its global vision.

![Heatmap](Netflix%20Project/images/content-by-country.png)

---

## 🔬 Additional Explorations

Alongside the main findings, a few other patterns stood out:

* **Movies Dominate the Catalog:** Nearly 70% of all titles on the platform are movies. That alone shapes user experience — and possibly even perception of what "Netflix content" means.  

![Content Proportion](Netflix%20Project/images/movies-tvshows.png)

---

* **Drama and International Content Lead:** Across genres, international productions and dramas are the most common. It reinforces Netflix’s commitment to global storytelling — often with serious, adult-oriented themes.

![Top 10 Genres](Netflix%20Project/images/top10-genres.png)

---

* **The Rise of India:** A year-by-year breakdown by country shows India rapidly rising as Netflix’s second-largest content source, even surpassing the UK. It's a major signal of where Netflix is betting its chips next.  

![Key Market](Netflix%20Project/images/titles-by-countries.png)

---

## 💡 Conclusion

Netflix’s content strategy isn’t one-size-fits-all. It’s a carefully tuned machine: conservative when it needs to be (movies), experimental when it can afford to be (TV Shows), and increasingly global in how it sources and presents content.

Its massive growth phase between 2018–2020 laid the groundwork, but recent years show a shift toward refinement — choosing quality over quantity, and global appeal over local dominance. In short, Netflix is no longer just building a library; it's curating an ecosystem.

---

## ⚙️ How to Run This Project Locally

1. Clone this repository to your local machine.  
2. Make sure R and RStudio are installed.  
3. Install the required libraries (listed at the top of the script).  
4. Open `main_project.R` — the dataset is in the `Netflix Project` folder and should load using a relative path.  
5. Run the script from top to bottom to reproduce all analyses and visuals.

---

## 👨‍💻 Author

**Henry Bertagna Lautenschlager** 
- [LinkedIn](https://www.linkedin.com/in/henry-bertagna-5b1554338)
- [GitHub](https://github.com/1hnry)



