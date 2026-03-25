-- Mart: Tournament performance by conference
-- Answers: which conferences produce the deepest runs?

with teams as (
    select * from {{ ref('stg_tournament') }}
),

conf_stats as (
    select
        conference,
        count(*)                                                        as total_bids,
        count(distinct season)                                          as seasons_represented,
        sum(case when is_champion = 'Yes' then 1 else 0 end)           as championships,
        sum(case when reached_championship = 'Yes' then 1 else 0 end)  as title_game_appearances,
        sum(case when reached_final_four = 'Yes' then 1 else 0 end)    as final_fours,
        round(avg(seed), 1)                                            as avg_seed,
        round(avg(pre_tourney_rank), 1)                                as avg_kenpom_rank
    from teams
    group by conference
    having count(*) >= 5
)

select
    conference,
    total_bids,
    seasons_represented,
    championships,
    title_game_appearances,
    final_fours,
    avg_seed,
    avg_kenpom_rank,
    round(championships * 100.0 / total_bids, 2)    as championship_rate,
    round(final_fours * 100.0 / total_bids, 1)      as final_four_rate
from conf_stats
order by championships desc, final_fours desc
