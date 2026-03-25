-- Staging model: clean and standardize raw March Madness data
-- One row per team per season

with source as (
    select * from {{ ref('march_madness_raw') }}
),

cleaned as (
    select
        -- Identity
        "Season"                        as season,
        "Full Team Name"                as team_name,
        "Mapped ESPN Team Name"         as team_short,
        "Mapped Conference Name"        as conference,
        "Region"                        as region,
        "Seed"::integer                 as seed,

        -- Tournament outcome flags
        "Tournament Winner?"            as is_champion,
        "Tournament Championship?"      as reached_championship,
        "Final Four?"                   as reached_final_four,
        "Post-Season Tournament"        as tournament_name,

        -- NOTE: coach data is excluded — source only contains current coaches,
        -- not historical coaches per season, making it unreliable for analysis

        -- KenPom pre-tournament ratings (what we knew BEFORE games were played)
        "Pre-Tournament.AdjEM"::float   as pre_tourney_adj_em,
        "Pre-Tournament.RankAdjEM"::integer as pre_tourney_rank,
        "Pre-Tournament.AdjOE"::float   as pre_tourney_offense,
        "Pre-Tournament.AdjDE"::float   as pre_tourney_defense,

        -- Season-long KenPom ratings
        "AdjEM"::float                  as season_adj_em,
        "Net Rating"::float             as net_rating,
        "Net Rating Rank"::integer      as net_rating_rank,

        -- Coaching tenure
        "Active Coaching Length"        as coaching_tenure,
        "Since"::varchar                as coach_since

    from source
    where "Post-Season Tournament" = 'March Madness'
      and "Seed" is not null
)

select * from cleaned
