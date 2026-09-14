MEELOC WEB FRONTEND V1
=======================

This is a FRONT-END DEMO only (no Laravel/MySQL/backend yet).

Pages:
- index.html                 Customer storefront
- delivery-register.html     Delivery partner registration
- delivery-dashboard.html    Delivery partner dashboard
- seller-register.html       Store/seller registration
- seller-dashboard.html      Store/seller dashboard

Local test:
Open index.html in Chrome.

GitHub -> Vercel test:
1. Create a new GitHub repository, e.g. meeloc-web.
2. Upload ALL files/folders from this package (not the outer ZIP itself).
3. In Vercel, New Project -> Import Git Repository.
4. Framework Preset: Other.
5. Build Command: leave empty.
6. Output Directory: leave empty.
7. Deploy.
8. Vercel will give a temporary *.vercel.app URL.

Custom domain after testing:
Use your own domain only after the Vercel preview is correct.
In Vercel Project -> Settings -> Domains -> add the domain.
Then follow the DNS records Vercel shows for your DNS provider.
Do not delete unrelated email/DNS records.
