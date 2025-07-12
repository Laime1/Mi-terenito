1 graph TD
2     subgraph "Punto de Entrada"
3         A[main.dart]
4     end
5
6     subgraph "Core"
7         B(MyApp)
8         C(Provider <ThemeProvider>)
9         D[ApiService]
10     end
11
12     subgraph "Modelos de Datos"
13         M1[Property Models\n(House, Land, Apartment, etc.)]
14         M2[UI Models\n(AppTheme, AppColors)]
15         M3[Data Models\n(User, City, Company)]
16     end
17
18     subgraph "Servicios"
19         S1[api_service.dart]
20         S2[theme_provider.dart]
21     end
22
23     subgraph "Pantallas (Screens)"
24         P1(HomeScreen)
25         P2(LoginScreen)
26         P3(Home2Screen)
27         P4(CasasScreen)
28         P5(LandsScreen)
29         P6(ApartmentsScreen)
30         P7(RentalsScreen)
31         P8(DetalleCasaScreen)
32         P9(DetailLandScreen)
33         P10(ApartmentDetailScreen)
34         P11(RentalDetailScreen)
35         P12(FormHouseScreen)
36         P13(LandFormScreen)
37         P14(DepartmentFormScreen)
38         P15(RentalFormScreen)
39     end
40
41     subgraph "Widgets Reutilizables"
42         W1[Property Cards\n(HouseCard, LandCard, etc.)]
43         W2[CustomSearchBar]
44         W3[CustomDropdown]
45         W4[CardCarrusel]
46         W5[TableCard]
47         W6[LoaderOverlay]
48         W7[CardMixin]
49         W8[Utils\n(AppLauncher, UrlMapField)]
50     end
51
52     %% Conexiones
53     A --> B
54     B --> C
55     B --> P1
56     B --> P3
57
58     C --> S2
59     S2 --> B
60
61     P1 --> S1
62     P1 --> W3
63     P1 --> P2
64     P1 --> P3
65
66     P2 --> S1
67     P2 --> P3
68
69     P3 --> P4
70     P3 --> P5
71     P3 --> P6
72     P3 --> P7
73     P3 --> P1
74
75     P4 --> S1; P4 --> W1; P4 --> W2; P4 --> W6; P4 --> P8; P4 --> P12
76     P5 --> S1; P5 --> W1; P5 --> W2; P5 --> W6; P5 --> P9; P5 --> P13
77     P6 --> S1; P6 --> W1; P6 --> W2; P6 --> W6; P6 --> P10; P6 --> P14
78     P7 --> S1; P7 --> W1; P7 --> W2; P7 --> W6; P7 --> P11; P7 --> P15
79
80     P8 --> S1; P8 --> W4; P8 --> W5; P8 --> W8
81     P9 --> S1; P9 --> W4; P9 --> W5; P9 --> W8
82     P10 --> S1; P10 --> W4; P10 --> W5; P10 --> W8
83     P11 --> S1; P11 --> W4; P11 --> W5; P11 --> W8
84
85     P12 --> S1; P12 --> W8
86     P13 --> S1; P13 --> W8
87     P14 --> S1; P14 --> W8
88     P15 --> S1; P15 --> W8
89
90     S1 --> M1
91     S1 --> M3
92
93     W1 --> W7
94     W1 --> S1
95     W1 --> M1
96
97     classDef default fill:#2d2d2d,stroke:#333,stroke-width:2px,color:#fff;
98     classDef screen fill:#023e8a,stroke:#00b4d8,color:white;
99     classDef service fill:#006400,stroke:#2e8b57,color:white;
100     classDef widget fill:#582f0e,stroke:#7f4f24,color:white;
101     classDef model fill:#4a4e69,stroke:#9a8c98,color:white;
102     classDef entry fill:#800f2f,stroke:#a4133c,color:white;
103
104     class A,B,C entry
105     class P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15 screen
106     class S1,S2 service
107     class W1,W2,W3,W4,W5,W6,W7,W8 widget
108     class M1,M2,M3 model
