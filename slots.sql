with booked_list as (
    select 
        et.id as id_booked,
        sc.school_class_type as level,
        case 
            when s.name like 'ld_%' then substring(s.name from 4) 
            else s.name 
        end as subject
    from calendars.event_participant ep
    left join calendars.event_term et on ep.term_id = et.id
    left join calendars.calendar_event ce on et.event_id = ce.id
    left join school.class_student scs on ep.student_id = scs.student_id
    left join school.class sc on scs.school_class_id = sc.id
    left join school.course_subject s on ep.subject_id = s.id
    left join school.student_data as sd on ep.student_id = sd.student_id
    where et.start>'2025-08-31'
      and ce.event_type='EXAM_TERM'
      and scs.school_year='2025/2026'
      and sd.is_technical_account=false
      and sd.is_staff=false
),
shared_list as (
    select 
        et.id as id_shared,
        ts.school_class_type as level,
        case 
            when s.name like 'ld_%' then substring(s.name from 4) 
            else s.name 
        end as subject
    from calendars.calendar_event as ce
    left join calendars.event_term et on ce.id = et.event_id
    left join school.teacher_data td on et.organizer_id = td.teacher_id
    left join school.users u on td.user_id = u.id
    left join school.teacher_subject ts on et.organizer_id = ts.teacher_id
    left join school.course_subject as s on ts.subject_id = s.id
    where et.start>'2025-08-31'
      and ce.event_type = 'EXAM_TERM'
      and u.is_technical_account = false
      and u.is_staff = false
      and u.is_active = true
      and u.email like '%@ourschool.edu'
),
booked as (
    select 
        level, 
        subject, 
        count(distinct id_booked) as booked_slots
    from booked_list
    group by subject, level
),
shared as (
    select 
        sl.level, 
        sl.subject, 
        count(distinct sl.id_shared) as shared_slots,
        count(distinct sl.id_shared) filter (where bl.id_booked is null) as free_slots
    from shared_list as sl
    left join booked_list as bl on sl.id_shared = bl.id_booked
    group by sl.subject, sl.level
)
select 
    coalesce(s.level, b.level) as level,
    coalesce(s.subject, b.subject) as subject,
    coalesce(s.shared_slots, 0) as "shared slots",
    coalesce(b.booked_slots, 0) as "booked slots",
    coalesce(s.free_slots, 0) as "free slots"
from shared as s
full join booked as b 
    on b.level = s.level
   and b.subject = s.subject
order by subject, level;
