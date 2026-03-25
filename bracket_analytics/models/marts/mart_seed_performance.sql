-- Mart: Historical performance by seed number
-- Answers: which seeds over/underperform expectations?

with teams as (
    select * from {{ ref('stg_tournament') }}
),

seed_stats as (
    select
        seed,
        count(*)                                            as appearances,
        sum(case when is_champion = 'Yes' then 1 else 0 end)         as championships,
        sum(case when reached_championship = 'Yes' then 1 else 0 end) as championship_games,
        sum(case when reached_final_four = 'Yes' then 1 else 0 end)   as final_fours,
        round(avg(pre_tourney_adj_em), 2)                  as avg_adj_em,
        round(avg(pre_tourney_rank), 1)                    as avg_kenpom_rank,
        round(avg(net_rating), 2)                          as avg_net_rating
    from teams
    group by seed
)

select
    seed,
    appearances,
    championships,
    championship_games,
    final_fours,
    round(championships * 100.0 / appearances, 1)      as championship_pct,
    round(final_fours * 100.0 / appearances, 1)        as final_four_pct,
    avg_adj_em,
    avg_kenpom_rank,
    avg_net_rating
from seed_stats
order by seed
