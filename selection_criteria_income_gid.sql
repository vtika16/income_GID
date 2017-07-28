SELECT as_of_dt
,isd.bus_proc_dt
,isd.row_proc_dt
,pf.portf_cd
,isd.sec_id
,pf.lot_num
,pf.cur_basis_cd
,pf.cost_basis_cd
,isd.intrnl_sec_id
,pf.gl_grp_nm 
,isd.gl_grp_cd
,acn.stat_sched_d_cd
,isd.sec_desc
,acq_trade_dt
,base_amt
,prev_day_bv_amt
,acq_bv_amt
,disp_bv_amt
,pf.bv_amt
,incm_rcv_amt
,acru_int_lcur_amt
,earn_int_amt
,earn_disc_acret_amt
,amort_prem_amt
,net_acret_amort_amt
,incm_earn_amt
,fx_real_incm_gain_loss_amt
,lt_fx_real_gain_loss_amt
,earn_incm_amt
,tranf.tran_type_cd
,pf.unit_num
,bv_crnt_amt
,pf.mv_amt
,end_cv_unrl_gain_loss_amt
,acru_int_orig_amt
,earn_int_amt
,orig_fx_tot_incm_amt
,earn_incm_amt
,amort_earn_prem_amt
,earn_disc_acret_amt
,lt_real_gain_loss_amt
,st_real_gain_loss_amt
--,acn.incm_impr_amt
,isd.actn_cd
,isd.issr_d_id
,isd.iss_d_id
,val_f_id
,pf.ref_portf_id
,isd.ref_coa_id
,rle.ref_lgl_ent_id
,rc.ref_client_id
,val.ref_mth_id
,isd.created_dt
,isd.created_by
,isd.last_updated_dt
,isd.last_updated_by
,isd.src_nm
,rp.portf_nm

FROM [dbo].[POSITION_F] pf

--FROM [dbo].[VALUATION_F] val

INNER JOIN [dbo].[ISSUE_D] isd
ON (pf.iss_d_id = isd.iss_d_id and isd.row_latest_fl = 'Y' 
AND pf.issr_d_id = isd.issr_d_id
AND isd.intrnl_sec_id = pf.intrnl_sec_id)

INNER JOIN [dbo].[ISSUER_D] isrd
ON isrd.issr_d_id = pf.issr_d_id

LEFT JOIN [dbo].[VALUATION_F] val
ON (pf.iss_d_id = val.iss_d_id 
AND pf.lot_num = val.lot_num 
AND pf.cost_basis_cd = val.cost_basis_cd 
AND pf.cur_basis_cd = val.cur_basis_cd)

LEFT JOIN [dbo].[ACN_DETAIL] acn
ON (acn.ref_portf_id = pf.ref_portf_id 
AND acn.iss_d_id = pf.iss_d_id 
AND pf.as_of_dt = acn.to_dt 
AND acn.cost_basis_cd = pf.cost_basis_cd 
AND acn.cur_basis_cd = pf.cur_basis_cd
AND acn.sec_id = pf.sec_id
AND acn.portf_cd = pf.portf_cd)

LEFT JOIN [dbo].[TRANSACTION_F] tranf
ON (tranf.ref_portf_id = pf.ref_portf_id 
AND tranf.iss_d_id = pf.iss_d_id 
AND tranf.portf_cd = pf.portf_cd 
AND tranf.sec_id = pf.sec_id
AND tranf.intrnl_sec_id = pf.intrnl_sec_id
AND tranf.cost_basis_cd = pf.cost_basis_cd
AND tranf.cur_basis_cd = pf.cur_basis_cd)

LEFT JOIN [dbo].[SECURITY_INCOME_TRAN_F] sitf
ON (sitf.ref_portf_id = pf.ref_portf_id 
AND sitf.iss_d_id = pf.iss_d_id 
AND pf.intrnl_sec_id = sitf.intrnl_sec_id
AND sitf.cur_basis_cd = pf.cur_basis_cd 
AND sitf.cost_basis_cd = pf.cost_basis_cd
AND sitf.portf_cd = pf.portf_cd)

INNER JOIN [dbo].[REF_CLIENT] rc
ON pf.client_id = rc.client_id and rc.row_stat_nm = 'Y'

INNER JOIN [dbo].REF_PORTFOLIO rp
on pf.ref_portf_id = rp.ref_portf_id AND rp.portf_cd = pf.portf_cd AND rp.row_stat_nm = 'Y'

INNER JOIN [dbo].REF_LEGAL_ENTITY rle
on rp.ref_lgl_ent_id = rle.ref_lgl_ent_id AND rle.row_stat_nm = 'Y'

--check for duplicates
GROUP BY as_of_dt
,isd.bus_proc_dt
,isd.row_proc_dt
,pf.portf_cd
,isd.sec_id
,pf.lot_num
,pf.cur_basis_cd
,pf.cost_basis_cd
,isd.intrnl_sec_id
,pf.gl_grp_nm 
,isd.gl_grp_cd
,acn.stat_sched_d_cd
,isd.sec_desc
,acq_trade_dt
,base_amt
,prev_day_bv_amt
,acq_bv_amt
,disp_bv_amt
,pf.bv_amt
,incm_rcv_amt
,acru_int_lcur_amt
,earn_int_amt
,earn_disc_acret_amt
,amort_prem_amt
,net_acret_amort_amt
,incm_earn_amt
,fx_real_incm_gain_loss_amt
,lt_fx_real_gain_loss_amt
,earn_incm_amt
,tranf.tran_type_cd
,pf.unit_num
,bv_crnt_amt
,pf.mv_amt
,end_cv_unrl_gain_loss_amt
,acru_int_orig_amt
,earn_int_amt
,orig_fx_tot_incm_amt
,earn_incm_amt
,amort_earn_prem_amt
,earn_disc_acret_amt
,lt_real_gain_loss_amt
,st_real_gain_loss_amt
--,acn.incm_impr_amt
,isd.actn_cd
,isd.issr_d_id
,isd.iss_d_id
,val_f_id
,pf.ref_portf_id
,isd.ref_coa_id
,rle.ref_lgl_ent_id
,rc.ref_client_id
,val.ref_mth_id
,isd.created_dt
,isd.created_by
,isd.last_updated_dt
,isd.last_updated_by
,isd.src_nm
,rp.portf_nm

HAVING(COUNT(*) > 1)


-- to see any fields that are null where it should be Not Null 
/*WHERE as_of_dt IS NULL
OR isd.bus_proc_dt IS NULL
OR isd.row_proc_dt IS NULL
OR pf.lot_num IS NULL
OR isd.issr_d_id IS NULL
OR isd.iss_d_id IS NULL
OR val_f_id IS NULL
OR pf.ref_portf_id IS NULL
OR isd.ref_coa_id IS NULL
OR rle.ref_lgl_ent_id IS NULL
OR ref_client_id IS NULL
OR val.ref_mth_id IS NULL
OR isd.created_dt IS NULL
OR isd.created_by IS NULL
OR isd.last_updated_dt IS NULL
OR isd.last_updated_by IS NULL
OR isd.src_nm IS NULL*/
