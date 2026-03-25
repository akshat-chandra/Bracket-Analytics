-- Mart: Cinderella teams — lower seeds that outperformed expectations
-- Answers: where do upsets most commonly happen?

with teams as (
    select * from {{ ref('stg_tournament') }}
),

-- Flag teams that went further than their seed typically does
upsets as (
    select
        season,
        team_name,
        conference,
        seed,
        region,
        pre_tourney_rank,
        is_champion,
        reached_final_four,
        reached_championship,

        -- A team is a "Cinderella" if seed > 8 and made Final Four or better
        case
            when seed >= 11 and reached_final_four = 'Yes' then 'Major Upset'
            when seed between 8 and 10 and reached_final_four = 'Yes' then 'Upset'
            when seed >= 8 and reached_championship = 'Yes' then 'Deep Run'
            else 'Expected'
        end as upset_category

    from teams
)

select * from upsets
where upset_category != 'Expected'
order by season desc, seed desc
