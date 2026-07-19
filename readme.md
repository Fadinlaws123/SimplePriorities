<div align="center">

# 🚦 SimplePriorities

### A configurable dual priority and peacetime system for FiveM roleplay servers.

<p>
  <a href="https://simpledevelopments.org/store"><img src="https://img.shields.io/badge/Explore_Our_Store-5865F2?style=for-the-badge&logo=googlechrome&logoColor=white" /></a>
  <a href="https://discord.gg/RquDVTfDwu"><img src="https://img.shields.io/badge/Join_Our_Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white" /></a>
  <a href="https://github.com/Fadinlaws123/SimplePriorities"><img src="https://img.shields.io/badge/View_on_GitHub-181717?style=for-the-badge&logo=github&logoColor=white" /></a>
</p>

<p>
  <img src="https://img.shields.io/badge/FiveM-Standalone-FF6B35?style=flat-square&logo=fivem&logoColor=white" />
  <img src="https://img.shields.io/badge/Priority-Dual_System-238636?style=flat-square" />
  <img src="https://img.shields.io/badge/Status-Release_Ready-238636?style=flat-square" />
  <img src="https://img.shields.io/github/stars/Fadinlaws123/SimplePriorities?style=flat-square&logo=github&label=Stars" />
</p>

</div>

---

## 📖 About

**SimplePriorities** provides two separate priority systems for roleplay servers, allowing different areas such as city and county to manage their priority status independently.

The resource also includes peacetime controls, cooldown and reset permissions, and logging for priority-related activity such as starting, joining, and leaving priority scenes.

---

## ✨ Features

- Two independent priority systems
- City and county priority support
- Priority availability and cooldown states
- On-hold controls
- Peacetime management
- ACE permission controls
- Activity logging
- Configurable settings through `Config.lua`
- Designed to integrate with other SimpleDevelopments resources such as SimpleHUD

---

## 🔐 ACE Permissions

Default permission strings include:

| Action | Permission |
| --- | --- |
| Manage Peacetime | `pt.admin` |
| Place Priority On Hold | `pt.onhold` |
| Manage Priority Cooldown | `prio.cooldown` |
| Reset Priority | `prio.reset` |

These values can be changed through the resource configuration.

---

## 📸 Preview

<div align="center">

<img width="48%" src="https://github.com/Fadinlaws123/SimplePriorities/assets/144308790/1e6444a2-2ec4-4035-84ef-c25e685554fe" alt="SimplePriorities preview" />
<img width="48%" src="https://github.com/Fadinlaws123/SimplePriorities/assets/144308790/6fb7a6f5-9332-43e1-afe4-1383269c7ad5" alt="SimplePriorities preview" />

<img width="48%" src="https://github.com/Fadinlaws123/SimplePriorities/assets/144308790/2d321198-bb9e-4731-8280-a0c9c8eb79d7" alt="SimplePriorities preview" />
<img width="48%" src="https://github.com/Fadinlaws123/SimplePriorities/assets/144308790/a2a43c2b-92ef-47f0-b75b-c542f90f269e" alt="SimplePriorities preview" />

<img width="48%" src="https://github.com/Fadinlaws123/SimplePriorities/assets/144308790/17622e96-1ede-4a13-ba79-96633754e509" alt="SimplePriorities preview" />
<img width="48%" src="https://github.com/Fadinlaws123/SimplePriorities/assets/144308790/6c182874-0a89-42bb-bca4-8c9660f33010" alt="SimplePriorities preview" />

</div>

---

## ⚙️ Configuration

SimplePriorities is configured through `Config.lua`, including the priority systems, permissions, logging, and other server-specific options.

---

## 📥 Installation

1. Place the resource in your server's resources directory as `SimplePriorities`.
2. Configure `Config.lua`.
3. Add the following to your `server.cfg`:

```cfg
ensure SimplePriorities
```

4. Add the required ACE permissions.
5. Restart the resource or server.

---

## 📋 Requirements

- FiveM server
- No framework required

---

## 🌐 SimpleDevelopments

SimplePriorities is developed and maintained by **SimpleDevelopments**.

<div align="center">

### Keep it Simple. Keep it SimpleDevelopments.

</div>
