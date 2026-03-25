import duckdb
import pandas as pd
import streamlit as st
import plotly.express as px

DB_PATH = "/Users/akshatchandra/Documents/LLM/Job_Search/Work Portfolio/BracketAnalytics/bracket.duckdb"

st.set_page_config(page_title="March Madness Analytics", layout="wide")
st.title("March Madness Analytics")
st.caption("Built with dbt + DuckDB | 2002–2026 tournament data")

@st.cache_data
def query(sql):
    con = duckdb.connect(DB_PATH, read_only=True)
    df = con.execute(sql).df()
    con.close()
    return df

tab1, tab2, tab3 = st.tabs([
    "Seed Performance", "Cinderella Stories", "Conference Power"
])

# ── Tab 1: Seed Performance ───────────────────────────────────────────────────
with tab1:
    st.subheader("Historical Performance by Seed")
    st.caption("Which seeds over or underperform expectations?")

    df = query("SELECT * FROM mart_seed_performance ORDER BY seed")

    col1, col2, col3 = st.columns(3)
    col1.metric("Seeds Tracked", len(df))
    col2.metric("Total Appearances", int(df["appearances"].sum()))
    col3.metric("Years of Data", "2002–2026")

    fig = px.bar(
        df, x="seed", y="final_four_pct",
        title="Final Four % by Seed",
        labels={"seed": "Seed", "final_four_pct": "Final Four %"},
        color="final_four_pct", color_continuous_scale="Blues"
    )
    st.plotly_chart(fig, use_container_width=True)

    fig2 = px.scatter(
        df, x="seed", y="avg_kenpom_rank",
        size="appearances", title="Avg KenPom Rank by Seed",
        labels={"seed": "Seed", "avg_kenpom_rank": "Avg KenPom Rank"},
    )
    st.plotly_chart(fig2, use_container_width=True)

    with st.expander("Full seed data"):
        st.dataframe(df, use_container_width=True, hide_index=True)

# ── Tab 2: Cinderella Stories ─────────────────────────────────────────────────
with tab2:
    st.subheader("Cinderella Stories")
    st.caption("Lower seeds that made deep tournament runs")

    df = query("SELECT * FROM mart_upset_tracker ORDER BY season DESC")

    major = df[df["upset_category"] == "Major Upset"]
    st.metric("Major Upsets (Seed 11+ to Final Four)", len(major))

    fig = px.histogram(
        df, x="seed", color="upset_category",
        title="Upset Distribution by Seed",
        labels={"seed": "Seed", "count": "Count"},
        barmode="group"
    )
    st.plotly_chart(fig, use_container_width=True)

    st.markdown("### All Cinderella Teams")
    st.dataframe(
        df[["season", "team_name", "seed", "conference", "upset_category"]],
        use_container_width=True, hide_index=True
    )

# ── Tab 3: Conference Power ───────────────────────────────────────────────────
with tab3:
    st.subheader("Conference Power Rankings")
    st.caption("Which conferences produce the deepest tournament runs?")

    df = query("SELECT * FROM mart_conference_performance ORDER BY championships DESC")

    fig = px.bar(
        df.head(15), x="conference", y="final_four_rate",
        title="Final Four Rate by Conference",
        labels={"conference": "Conference", "final_four_rate": "Final Four %"},
        color="championships", color_continuous_scale="Reds"
    )
    fig.update_xaxes(tickangle=45)
    st.plotly_chart(fig, use_container_width=True)

    st.dataframe(
        df[["conference", "total_bids", "championships", "final_fours",
            "avg_seed", "final_four_rate"]],
        use_container_width=True, hide_index=True
    )

st.divider()
st.caption("Data source: Kaggle — March Madness Historical Dataset 2002-2026 | Pipeline: dbt + DuckDB")
