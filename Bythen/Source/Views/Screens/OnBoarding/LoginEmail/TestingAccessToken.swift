//
//  TestingAccessToken.swift
//  Bythen
//
//  Created by Ega Setya on 31/12/24.
//

struct TestingAccessToken {
    static let shared = TestingAccessToken()
    
    // hive access token
    let haveAllUser = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhaWQiOiI0MiIsImF0IjoidXkzak53Rm9qa2FDMGNLSGJSODZreExxU0d2bU01bUZzYkZiOWZqd3NhZ3dKd2lXa2tlSjU5czgycWNHQlQzZ0N6NnNOeU8zYmYwb2wxRGNnV0diSXciLCJhdHkiOiJ1c2VyIn0.FvPdIFvMLQND_LPVL3TbqaaPTu_rAdZcGls2-qqaYKU9RbavjKfPbVH7y2t-42p3WG1_51HFwleZ0p6o01kCMytLH2_QBNEfUZEnmHFbuBFLgOoA-noitEvaB80aomCftgQ-z96U1UffPxwDlzJML5ds4zpie5z06K_cuSHHjeHCJVaElhElrBV47YFYIIBw-nJNIuMQih8hFbe6bXZlcvWndKwR2m2q-XggIKlWdV0ms827hlDzkfJdADR-FlMXku1gx76vufWQfBVOjw2PMgwcRKQnjHiAno_BwB8jFXEG-Jm4xVe7OT014VkD_Jl4ZX1-fcnYyZQ0t4aopDlt5cgfey0tB2BdIewo-j1YnQHJfsP68hNOO7GqTdl4VZgAukih6bl_Wvw0GakwhXf3SpiQfdY671xfoX278E7q_eWrHjmcBp1ECTHd32LhRv_2amQVn125z5QcSGWbK3zLJ1EBsEw35XtQp_u2ICkV5RoArRb7OkhjMB02moy3sDI6rdEdiPSuTrDxz69B0kqT1GqQZIeRLGXbd2I8-qsEMDzAmpraWGr2vupB7MmywdMg8w0nle1aRBhfRIiODPlygonbiCQdjQ-XoSrVvYRFE_vp3s2Bv9i5jByaVVEL1vL65Ac4SWjvlwL_Nir04JM0GT2-OW29FvjYTn7sFp3vjBU"
    
    // User that have no bytes, but have hive product
    let hiveOnlyUser = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhaWQiOiIyMzAiLCJhdCI6IkwyVnMrd2ZET1FJZHJqQUh0WC9YOXRYZnVTVHY3T3BtMVhqQUdBMUlzV25ZRnlqaEp5NGp0TTI4RG16M2VyLy9kbU5JbC9oMTNFSzAvY0pNNXc0QldnIiwiYXR5IjoidXNlciJ9.BpRI6j8kouVXP1SaT_Z8Lw5Odar048TtcMAmMTU38gbF3vjrfsuBpMN3AtPI_GIGnThLfl38I2CtVxccoWuwbzsKKcO87OStlP61klncXlArNZzqo-Cn5Q_lPH1IVHDJv4hsQdq8QmmxC3fBL3q9pzCosb19I2-p_Y_UIilYX6ltWqNBxHeRCz1spcmGyBrBwWvMthyl2xEB0v8-TajN7rWwf_n5LTvD66Wa3qN3ujvKrrt9yIJmyNGi-mhq-eukTuMLgqi6itmTMu9ymbi__pr0MRLElsJa8ozK-h2yqu8V8pgjaxm0eOHP72V4l6TB04fjgJwamylACvc6KuPfy7oKy4_uhxiwY7v0V8WskifBKlxvCvVpTEoxT7v2KtQ1jEvjozCsxKeNTXrvtlTkf_405ifEklQzbBkre8ECN-H1Vau_Ak_uiDFNtLUb31tAPaFZdDFSbnfi0QMt_432yKFfikMw-we_-dEgvC9kmzPJj60dssSYHk8-G70q1D3tL4Mls009uRDgAMuiyEr6V3pGZumhalVDPeMV7Rutph04HGQhY4RjUlLa36rXS2sVv52LxD9mluh6O2fa498xTblisPHhtNXmFXwbaMJAzcr0gUVfuSIvninCh7m4Wb-rqMmxPvHVPuYHqYMeP5M6ExaXOQeFtjLGbwzim9ctPR8"
    
    // Havent done Account setup, fresh user
    let freshUser = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhaWQiOiIyOTIiLCJhdCI6IkgxMU1DaFF5ZTNuVzF6cGdBZy8wazU0ZXBUaEsxL01YekRQRnMvQW5ERXRuRXdkOW0wMmVvdE93Wm9Yck5yZjhnZDlaS3hhNnFTK0JscVRmd1VMeXN3IiwiYXR5IjoidXNlciJ9.Xs6svYlrX-nnttZMmA5XfWTg4ePBNiVwTYvyDSrx9kxGffGnBh__CxYxDwFuOdzvHu5xO-uaUWJoznLUs0kjbKy7GHORuRu0bYY0riZrToQZLayfoFt7zTPJo1PZiAL39FmquReaqk-q6KjWL4fPCAi1VU5v5AsVBSHsI_GjejXOaWtFuRifDqrzIFGEmfqDyAqI4vvfQVonmRmQjasJFcd2HaepxHGa2C4z7mAVDioFozd159Q5NQ4B4OVmVc4qOjaYSmIw0w2PH1YQexNfZlwQN4sS4WxV5jTTSZQg33SHsDH7ubEZHZmIerQ07nY2SWxb8GJvxaDXPlZyU5Jp_mVazfK5JwpnOlrSxasvY8PTUfdHIBgGkdHcA2Fg0Lwph4rveKjQ2HLLKvr8h6evR9pTSlHxResr6i9LA3r12S5IoFa4sZK1UlziqnB_JAwD8OfckjqCyIef_i2P9KYrzuY0rlMCa0WZQZqKyLqsCvLGHi3QH__CmaTHjgtEzzeXU6Sm8CFY9sipqDBNgfPnl1HpENDb2SooscojvA-J4Kj0nylQJ-6MU76RRU6wBUzcK-3rrt1fEThMM1mehExN_JvNdHlMdiAKsloheeQp_JjJJ14zlzVqoFXKA4lbXzHOTbQOAXd4mAc_FXHJNS6cXkwIV-FgK6J8shNAQkVgVCU"
    
    let noProductUser = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhaWQiOiIxOTYiLCJhdCI6InRjTG1PZThIMkhGalBhVi96bmRtYkhtN1NKd0FVWGREWjFWVXdiendMTWovWWNKa0RYZWxaZHVqZyt6LzBiYWVqYmZTNldTM0ZIV0k1MGw2SVI0dld3IiwiYXR5IjoidXNlciJ9.QjB5gM7bv2ou-KHdeeqyUkZJYuNo63PFtNNuBTLsqhPsY2XmJPGTkaswQpZN_XwAXQUt2c5wpJxLwJ-cdk1bQ8lC0pLftbF3HHzfEkFk9NgAkVQuTmMFSC0sRpqH0-BjVT0gbWgMKBQA2RCXSX7G4DbzF-RlcW0bWiH0_XiXJJkseulBGx5mhvWl09LPvC9drI4mO_emHQC3WOlXEctAJrJaALpWQdONrzQwxV_rxSBVbJwCmzKKRs59Ci2aiV0p3wUWeVo0D479UpQpgEN-qPgv4Q3EUxNVZQkPNC81FyW8IpwWij7ZoQLy0VKTr-iAsBCpwIPIN2MYZPIkqGqYaP8hJOysg_f9okhqIbGbS_TvqZTtL-Ed_k3i9toxJHA_BscAhYNaq6GAvaIGtULmX0tKyoFeWiMNaTJmWocNNR7n00pJ4HTx6SzVKihURCV7SroqL-IVINvKmHPCPKLzR7ftF7H7xFzsrL1vS3MpMsJ2dJUhHJgd2HCosef99F8zgIUYatqWNUGJIDTfT9DR_bZslaefC8_U9Ndwk1YuZ8E3CIWnu66L8pJpn7ffu7LSlTMcZ_NEkY_qc4XyH2dKTRPDRUHBZe6llAG3HVPuuoujT4lBeSd_tYLbAy9nICEYcDmnNPQGCMmwN8aog54eED2-fvwpV264VgYBeo5gt54"
    
    let hiveRoyalBeeToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhaWQiOiIxODYiLCJhdCI6IkJZekx0WUNvRkptMU9GSnpSR0RwVE5tQnNSYXB2WmtqM25GR2EzOGVkUmlvZWZFNVIwVnZ6R2xIejJacmN5b0gxL2lOb1AxQnhBUUxuYkl5NFptZWFnIiwiYXR5IjoidXNlciJ9.SBXiF6aQUCCbYI7IOtXxC_N86gfC-SioRpkRjvZ6yEOG8X3Kwrqco7Ohz5tH9DFuyv89lAZBrPwGqjZVg5uM9XEnJt6_mo6A_4JN918L-M_L-Q6BrzP76o-cPgPBtQbtCm9yAogWvWgtoK1G7wXTJgW01k3tOm4uolXanFyLcYZuyrc3YSvhpz279TqGfmNkbh6-IejLGDdafY_JpNaJprX6I-nphWQoDNZf-ynaH6jZIHabIxs2-cIiPlZVE_kCbdk4cTW0fXBoxaF8XE1vh3Bz9SpGPwEMaJ_21Pl1YTecgCbooTJBztweTWCRmEhoipBhvAdLOcDZxSLpNyeslktbSknQaP47pWEUVybmgnuLU9yEi0ZN6Kf5J8vgLtlRvCNTHlNqhkRMqKhaHLAZTdDrbgZPdbTfSFQxmbY4Plm9xz4omvXkDcN02aVL0OlTD0r4K-nSgb0roezBQXg3sZnO_ozb4xtr5eJskA1qMuUe1CzvmpFzfMPGTtw_7fTxFcwBG0BcWhV3Bb3ttx7ksr2Q3njldGA4uN4C4_-YNbudoUKsSCe6QC5lUR3kYE6KwFtQ5kcwQ_UN4isvcRLAhGbXnpOTGDQyi_l2pqEar9WkcXq1LceW8svPgo5Q4Z9BPSdU4Quh6LDM65GwOk5r8FswuvTihn5rnu29P8AzwWA"
    
    let hiveInactiveToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhaWQiOiIyMDIiLCJhdCI6IkNlbXB1WFB3Ui9nQmExZ2pjWGlqNjk4b1AvUG5ja0grQmlhRTJDK0FGdi9UajY4WUliRmRwNXltSXgzYmIwREUrNUVPMklHbG80NUVoaTNtUERIclVnIiwiYXR5IjoidXNlciJ9.Xlhc6ee1tNDoThjbGyCkLORULRBS3s77oMcvsKZVZEmYXJhhkK4vvSjOFNLMRQrx2hdDWveVKMEPhAdw6CctUfIZ0eMv-ufZ8thy4LU2SmAJAE4DLXPDC3_Hp1BtACan8TDlOIa_DpQ4YoJiL92h4rRupCYhC7IhdNm5tfY61AaoxyXV4TFQWZb5g5X_8SmIJA_5SfyA31IydipjytV1OJEJuiMMHoZWCzuELIoJC3boBEWknF9GUeT2H034rGJy58CiWDG0yGYT7niCe7vjMz1_HDxjzP-PRR3DNEddXmb6rJIINFEOIuCBLDVn4UGcDN2kastm0BIWWzhHBz87lQ45vO-IZahJZnToWmh_CzRe3yiHpe_z8wduLjnDSNnO3NkxiQECwLMpRUV_CtvlP3R6yz81BrQQW5QXTt0DNY64KdplrXQ1ZbB1jabUGnQM79vrn3zOL9hwMVIKJaG14NpThUii-LkOHQEG1heksll4KdOqoJ1rysTQ7vCEIFX3TZQA29hIPykFMCpdkZ33kmchL-GE27KI7MLMSXZ__AfoStSdwa1VQ-vwhZiQ5v5CaJhaD8eC9R3cwh7MBGxMiX8k0CMGWATwH_Mj5dIomr-es374Xaou9QxlhAtf4VfyNZXsz0aapaQ4k495F55huu3hNfdLtnyzmLOYI_5pO8E"
    
    let hiveTrialToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhaWQiOiIyMTIiLCJhdCI6IncxY2tkV29TaDd3SXgyWEtDbkZIb0VWN0U0T0hiSkJJemd3eFB1elVUT2ZWTG9hSGc4alBXWXZJMVN1eFJXaDF6TUJhMkRCMmhSQmUwbUJyRS9LTElRIiwiYXR5IjoidXNlciJ9.QLRMcJCxqDyYJQUVi_BTSwZHc2kFMGkxqbNBlU1zVF-C7wy6KMJcAt0Qh7dvWMw5w2VrYrvPFNNxYvq66wb3up4jT38OUOZ55uRztZOZy3Z26T2hg-5xW4Z7qHezP-Hv2QqhBqsDrM8GjB-ELm-Vl2pbHU_CsJZAytGCmbittCquRkn3XWAR5GdCIPqix6SimKDeFlkxr7TDdCBkLasfnXJBpWmK7G8vyM2-Wr5q0jozJyJ5dvc9asmJLJPEjm91_ZPH5aYIlW5PKNTEgOWSFYTv2Yu2qY4NrP2d_OXWALZsDxqmvAd9URKytotM_CRrDiH0De5v1Dqc-nHTccn9DrCFbfoz1IdagTUrY8NMqPtFnqnaPJ7pP8VsiUzNYhRL-Pl5McNyh0V7fpdhi0r9koY_JBDcXeNGPd1cj2g5NLHFKdqzSPBUOij67ZGc3wqpAiXx-K3_WuWHGs1_mKxwAjlWr83rW3Q7x2EQi7_p-E07Ma01FyjkdqYIzLz7Khy-DOlcgQX31Xp0SDXTa0BsvS9-t4djmF9mXJOi7VI5l6n5neXSa60O9_Yjf-C6-MVHT84lhkrtGz-CiUeG-4dQYGThTbnmzQfBzkcVpJGm54EDSwbAIPYDguwTLnmMpSPGBaZ9uIyDMr2kk9CWpDtO43XXw7xDomU-InTa-gDkwTc"
    
    let hiveActiveToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhaWQiOiIxNjYiLCJhdCI6ImFKMTE5dnFma0hOeU1sV1Awc1R0eXQ1OG91cUtPQTZnVms4djZNY2lZZVZaZDV5OUFXYTAyRWx4YW15N3VpSW1JN0FEdkN5L0RXWFJMZ1Nwckd0WnhBIiwiYXR5IjoidXNlciJ9.b9m2Jkr2PPwImU-kV95DAHh3Em-qUYd-azKmgnBOfUNmdd1gIv7Kk544kcTAtuVb-D4PeCRTsYZ0tW0T269O4OTFIXa1aAdpOEBQU2rJbtifmDcnjk1BWPh6HRy3MO9wYwD49t5czGso_qWCNUJJSnBF1rGV1Tl7PIvkbUrwDdNjmWFIwdM8Abqg0WVEFiFQuzFswHuQ8c3kjpcYRyZ-UJj-NT1cSPoty1UWoXi_C5brbK3mVDDoampUL-2kfmEHIeR2z2a2o-CmNhPWLiyU3583dBmNlxXfIW_8z1Z9vptx103Q6gdGVrBPZN5QJMS2Vao2sxM7P554v2htvFAE3eG0vBQStgqSl_QSTGGYoU96CeBzFjLcgtPW_svrHI-qclzzZQwTpPDt9yOIuIBgxVGoNtcgXPDmI237MG1iBkpmWhaJRASN3h7EBtSvjORNmsXxe7UgalQFMIbBAIqppMtI-3FV0j3oW7p3_WHy8Y_2LVGRA0p1Ka_7b1JflfSPgyXCdP1BxugCj0CDDSGbQcU3XxXlAY6mR4Apuo7ts4UuoF_s55q54MCn-kewNi3lDYTANqiGrAcywY8cGR7x16xbGRuWMDpHub_lI6NJoAni0OCS-1icfQSKTzZrdx5cRwS97bNXZGFlW9cCUMXz5lH_7Z71jY_TFwfrayTNbrA"
}
