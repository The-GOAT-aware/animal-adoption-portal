﻿namespace AnimalAdoption.Common.Logic
{
	public class AnimalService
    {
        public Animal[] ListAnimals => new Animal[] {
            new Animal { Id = 1, Name = "Sedi", Age = 50, Description = "Soft natured" },
            new Animal { Id = 2, Name = "Metamorph", Age = 50, Description = "Under a lot of pressure" },
            new Animal { Id = 3, Name = "Igno", Age = 50, Description = "Shiny and glasslike" },
            new Animal { Id = 4, Name = "GOAT", Age = 99, Description = "The GOAT team" },
            new Animal { Id = 5, Name = "Jimmie Bob", Age = 65, Description = "Very cool" }
        };
    }
}
