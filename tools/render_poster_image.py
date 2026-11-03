import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

def create_presentation_poster():
    # 1920 x 1080 Presentation Slide Poster (16:9 4K-ready)
    W, H = 1920, 1080
    poster = Image.new('RGB', (W, H), color=(9, 14, 23)) # Deep navy/obsidian #090e17
    draw = ImageDraw.Draw(poster)

    assets_dir = r'C:\Users\karth\Desktop\Veeramangai_Complete\public\assets'
    hero_path = os.path.join(assets_dir, 'hero_action.jpg')
    p1_path = os.path.join(assets_dir, 'poster1.jpg')
    p2_path = os.path.join(assets_dir, 'poster2.jpg')
    p3_path = os.path.join(assets_dir, 'poster3.jpg')
    p4_path = os.path.join(assets_dir, 'poster4.jpg')

    # Load Fonts
    try:
        font_hero_title = ImageFont.truetype("arialbd.ttf", 46)
        font_title_ta = ImageFont.truetype("arialbd.ttf", 24)
        font_tagline = ImageFont.truetype("arialbd.ttf", 15)
        font_h2 = ImageFont.truetype("arialbd.ttf", 22)
        font_card_title = ImageFont.truetype("arialbd.ttf", 16)
        font_body = ImageFont.truetype("arial.ttf", 13)
        font_badge = ImageFont.truetype("arialbd.ttf", 11)
        font_small = ImageFont.truetype("arial.ttf", 11)
        font_stat_num = ImageFont.truetype("arialbd.ttf", 36)
    except:
        font_hero_title = ImageFont.load_default()
        font_title_ta = font_hero_title
        font_tagline = font_hero_title
        font_h2 = font_hero_title
        font_card_title = font_hero_title
        font_body = font_hero_title
        font_badge = font_hero_title
        font_small = font_hero_title
        font_stat_num = font_hero_title

    # Top Header Bar (0 to 110 px)
    draw.rectangle([(0, 0), (W, 110)], fill=(15, 23, 42))
    draw.line([(0, 110), (W, 110)], fill=(56, 189, 248), width=2)

    # Brand Mark
    draw.rounded_rectangle([(36, 20), (106, 90)], radius=12, fill=(2, 132, 199))
    draw.text((58, 28), "V", fill=(255, 255, 255), font=font_hero_title)

    # Title & Subtitle
    draw.text((126, 22), "VEERAMANGAI", fill=(255, 255, 255), font=font_hero_title)
    draw.text((128, 76), "THE SOVEREIGN ATHLETE INTELLIGENCE SYSTEM FOR INDIAN WOMEN IN SPORT", fill=(56, 189, 248), font=font_tagline)

    # Top Right Badges
    draw.rounded_rectangle([(W - 480, 26), (W - 250, 56)], radius=15, fill=(245, 158, 11), outline=(251, 191, 36))
    draw.text((W - 470, 34), "IDEATHON WINNER 2026", fill=(0, 0, 0), font=font_badge)

    draw.rounded_rectangle([(W - 230, 26), (W - 36, 56)], radius=15, fill=(16, 185, 129), outline=(52, 211, 153))
    draw.text((W - 220, 34), "DPDP ACT 2023 · ZKP", fill=(0, 0, 0), font=font_badge)

    draw.text((W - 480, 72), "Gemini 2.5 Flash Grounded Search · Flutter · Node.js", fill=(148, 163, 184), font=font_small)

    # LEFT COLUMN: Hero Athlete Visual & Problem Statement (x: 36 to 620)
    left_w = 580
    if os.path.exists(hero_path):
        hero_img = Image.open(hero_path)
        hero_img = hero_img.resize((left_w, 420), Image.Resampling.LANCZOS)
        poster.paste(hero_img, (36, 130))
        # Dark gradient bottom over image
        overlay = Image.new('RGBA', (left_w, 140), (0, 0, 0, 0))
        o_draw = ImageDraw.Draw(overlay)
        for y in range(140):
            alpha = int((y / 140) * 220)
            o_draw.line([(0, y), (left_w, y)], fill=(6, 9, 14, alpha))
        poster.paste(overlay, (36, 410), overlay)

    draw.rectangle([(36, 130), (36 + left_w, 550)], outline=(56, 189, 248), width=2)
    draw.text((54, 460), "83% RURAL FEMALE ATHLETE DROP-OUT", fill=(251, 191, 36), font=font_h2)
    draw.text((54, 495), "Invisible trials, corrupt funding intermediaries, unsafe transit & taboo menstrual nutrition.", fill=(226, 232, 240), font=font_body)
    draw.text((54, 520), "Veeramangai solves all 4 through autonomous athletic intelligence agents.", fill=(56, 189, 248), font=font_badge)

    # Problem vs Solution Breakdown Card (Below Hero Image, 570 to 880)
    draw.rounded_rectangle([(36, 570), (36 + left_w, 890)], radius=14, fill=(14, 21, 34), outline=(255, 255, 255, 30))
    draw.text((54, 586), "CORE HACKATHON INNOVATION & ARCHITECTURE", fill=(56, 189, 248), font=font_card_title)

    features = [
        ("Live Google Search Grounding", "Fetches real-time SDAT district trials & Khelo India meets with source URLs."),
        ("Zero-Knowledge Government Proofs", "Proves grant eligibility to SDAT without exposing Aadhaar or domestic location."),
        ("Differential Role-Based Privacy", "Coaches see anonymized squad readiness only; menstrual logs strictly locked."),
        ("Ephemeral Voice Assistant (Avvai)", "Live speech-to-text in volatile memory; zero voiceprints or recordings stored."),
        ("Kinematic Gait & Stride Vision Slot", "Clean drop-in REST endpoint ready for teammate biomechanical ML model.")
    ]

    cur_y = 620
    for title, desc in features:
        draw.text((54, cur_y), f"• {title}:", fill=(251, 191, 36), font=font_badge)
        draw.text((74, cur_y + 18), desc, fill=(203, 213, 225), font=font_small)
        cur_y += 50

    # Quick Metrics Row (895 to 975)
    draw.rounded_rectangle([(36, 905), (36 + left_w, 985)], radius=12, fill=(20, 28, 44), outline=(16, 185, 129))
    draw.text((56, 915), "14", fill=(16, 185, 129), font=font_stat_num)
    draw.text((56, 960), "ACTIVE TRIALS", fill=(148, 163, 184), font=font_badge)

    draw.text((220, 915), "₹6.28L", fill=(56, 189, 248), font=font_stat_num)
    draw.text((220, 960), "KHELO INDIA GRANT", fill=(148, 163, 184), font=font_badge)

    draw.text((430, 915), "99.4%", fill=(245, 158, 11), font=font_stat_num)
    draw.text((430, 960), "SAFETY RATING", fill=(148, 163, 184), font=font_badge)

    # RIGHT COLUMN: 4 SPECIALIST QUEEN POSTERS (x: 640 to 1884)
    draw.text((646, 130), "FOUR SPECIALIST ATHLETIC INTELLIGENCE AGENTS", fill=(56, 189, 248), font=font_h2)
    draw.text((646, 162), "Empowering Indian female athletes through historical warrior wisdom & cutting-edge AI.", fill=(148, 163, 184), font=font_body)

    queen_cards = [
        {
            "num": "01",
            "dynasty": "SIVAGANGA",
            "name": "VELU NACHIYAR",
            "ta": "வேலு நாச்சியார்",
            "role": "TRIALS & SCOUTING RADAR",
            "desc": "Live district tournament radar, Kabaddi trials & athletics selection calendar. AI cutoff analysis.",
            "stat": "14 Active Trials · 38 TN Districts",
            "color": (245, 158, 11),
            "img": p1_path
        },
        {
            "num": "02",
            "dynasty": "CHOLA REALM",
            "name": "SEMBIYAN MAHADEVI",
            "ta": "செம்பியன் மாதேவி",
            "role": "GRANTS & ENDOWMENTS",
            "desc": "Direct Benefit Transfer (DBT) matching. SDAT Champions Scheme (₹2L) & Khelo India Talent Scholarship.",
            "stat": "₹2L State Grant · ₹6.28L National Pool",
            "color": (16, 185, 129),
            "img": p2_path
        },
        {
            "num": "03",
            "dynasty": "MADURAI",
            "name": "RANI MANGAMMAL",
            "ta": "ராணி மங்கம்மாள்",
            "role": "SAFE TRANSIT CORRIDORS",
            "desc": "Chaperoned travel pods, 75% Southern Railway & TNSTC sports passes with 181 safety integration.",
            "stat": "38 Safe Corridors · 75% Fare Waiver",
            "color": (6, 182, 212),
            "img": p3_path
        },
        {
            "num": "04",
            "dynasty": "THANJAVUR",
            "name": "KUNDAVAI & AVVAI",
            "ta": "குந்தவை பிராட்டியார்",
            "role": "SPORTS SCIENCE & NUTRITION",
            "desc": "Bilingual AI coach. Cycle-synced training (follicular/luteal) & high-protein traditional fuels (ragi/sundal).",
            "stat": "4:1 Carb-Protein · Menstrual Sync",
            "color": (192, 132, 252),
            "img": p4_path
        }
    ]

    card_w = 294
    card_gap = 14
    start_x = 646
    card_y = 196
    card_h = 560

    for i, q in enumerate(queen_cards):
        cx = start_x + (i * (card_w + card_gap))
        
        # Card Background
        draw.rounded_rectangle([(cx, card_y), (cx + card_w, card_y + card_h)], radius=14, fill=(14, 20, 32), outline=q["color"], width=2)
        
        # Poster Image
        if os.path.exists(q["img"]):
            p_img = Image.open(q["img"])
            p_img = p_img.resize((card_w - 4, 320), Image.Resampling.LANCZOS)
            poster.paste(p_img, (cx + 2, card_y + 2))

        # Dynasty Tag Badge
        draw.rounded_rectangle([(cx + 10, card_y + 10), (cx + 140, card_y + 32)], radius=10, fill=(0, 0, 0, 200), outline=q["color"])
        draw.text((cx + 16, card_y + 14), f"{q['num']} / {q['dynasty']}", fill=q["color"], font=font_badge)

        # Content area
        content_y = card_y + 330
        draw.text((cx + 12, content_y), q["name"], fill=(255, 255, 255), font=font_card_title)
        draw.text((cx + 12, content_y + 24), q["role"], fill=q["color"], font=font_badge)
        
        # Description
        words = q["desc"].split()
        lines = []
        cur_line = []
        for w in words:
            cur_line.append(w)
            if len(" ".join(cur_line)) > 32:
                lines.append(" ".join(cur_line[:-1]))
                cur_line = [w]
        if cur_line:
            lines.append(" ".join(cur_line))

        line_y = content_y + 44
        for l in lines[:3]:
            draw.text((cx + 12, line_y), l, fill=(203, 213, 225), font=font_small)
            line_y += 18

        # Stat Badge bottom
        draw.rounded_rectangle([(cx + 10, card_y + card_h - 48), (cx + card_w - 10, card_y + card_h - 12)], radius=8, fill=(20, 28, 44), outline=q["color"])
        draw.text((cx + 16, card_y + card_h - 36), q["stat"], fill=(255, 255, 255), font=font_badge)

    # LOWER RIGHT SECTION: DIFFERENTIAL PRIVACY MATRIX & ZKP GOVERNMENT SHIELD (775 to 985)
    privacy_box_y = 775
    draw.rounded_rectangle([(646, privacy_box_y), (W - 36, 985)], radius=14, fill=(15, 23, 42), outline=(16, 185, 129), width=2)
    draw.text((666, privacy_box_y + 16), "SOVEREIGN PRIVACY VAULT & ZERO-KNOWLEDGE GOVERNMENT SHIELD", fill=(16, 185, 129), font=font_h2)
    draw.text((666, privacy_box_y + 46), "Protects female athletes against government surveillance, identity theft, and unauthorized data harvesting.", fill=(148, 163, 184), font=font_body)

    # 3 Persona Boxes
    box_w = 380
    personas = [
        ("👤 ATHLETE PERSONA", "Full Local Private Access", "Menstrual cycles (Follicular/Luteal), private resting heart rate, recovery HRV & safe travel GPS encrypted locally via AES-256-GCM hardware key.", (16, 185, 129)),
        ("👥 COACH PERSONA", "Differential Aggregate Only", "Coaches see anonymized squad readiness (94%) and drill intensity recommendations. Personal cycle days and private logs are 100% locked.", (245, 158, 11)),
        ("🏛️ GOVT / SDAT SHIELD", "Zero-Knowledge Proofs (ZKP)", "Certifies age standard, Tamil Nadu residency, and sports merit without submitting raw Aadhaar numbers, home address, or reproductive health biometrics.", (56, 189, 248))
    ]

    for j, (p_title, p_sub, p_text, p_col) in enumerate(personas):
        bx = 666 + (j * 395)
        by = privacy_box_y + 80
        draw.rounded_rectangle([(bx, by), (bx + box_w, by + 115)], radius=10, fill=(9, 14, 23), outline=p_col)
        draw.text((bx + 12, by + 10), p_title, fill=p_col, font=font_badge)
        draw.text((bx + 12, by + 28), p_sub, fill=(255, 255, 255), font=font_badge)
        
        words = p_text.split()
        lines = []
        cur = []
        for w in words:
            cur.append(w)
            if len(" ".join(cur)) > 45:
                lines.append(" ".join(cur[:-1]))
                cur = [w]
        if cur: lines.append(" ".join(cur))
        
        ly = by + 48
        for l in lines[:3]:
            draw.text((bx + 12, ly), l, fill=(203, 213, 225), font=font_small)
            ly += 16

    # BOTTOM FOOTER BAR (1000 to 1080)
    draw.rectangle([(0, 1000), (W, H)], fill=(6, 9, 14))
    draw.line([(0, 1000), (W, 1000)], fill=(56, 189, 248), width=1)
    draw.text((36, 1030), "PROJECT VEERAMANGAI · 2026 SPORTS IDEATHON PRESENTATION POSTER", fill=(255, 255, 255), font=font_badge)
    draw.text((646, 1030), "Stack: Gemini 2.5 Flash Search Grounding · Flutter SDK · Express Node.js · Web Audio Synth · DPDP Act 2023", fill=(148, 163, 184), font=font_badge)
    draw.text((W - 320, 1030), "Live Demo: http://localhost:5000", fill=(56, 189, 248), font=font_badge)

    # Save to both Desktop folder and public/assets
    out_desktop = r'C:\Users\karth\Desktop\Veeramangai_Complete\presentation_poster.png'
    out_public = os.path.join(assets_dir, 'presentation_poster.png')
    poster.save(out_desktop, quality=95)
    poster.save(out_public, quality=95)
    print(f"✓ Saved poster image to: {out_desktop}")
    print(f"✓ Saved poster image to: {out_public}")

if __name__ == '__main__':
    create_presentation_poster()

