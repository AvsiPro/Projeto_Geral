import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';

import { PoModule } from '@po-ui/ng-components';
import { PoStorageModule } from '@po-ui/ng-storage';
import { PoTemplatesModule } from '@po-ui/ng-templates';

import { AuthGuardService } from '../auth/auth-guard.service';
import { GenericService } from './../generic/service/generic.service';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,

    PoModule,
    PoTemplatesModule,
    PoStorageModule.forRoot({
      name: 'appconference',
      storeName: 'mystore',
      driverOrder: ['localstorage']
    })
  ],
  declarations: [],
  exports: [
    CommonModule,
    FormsModule,

    PoModule,
    PoTemplatesModule,
    PoStorageModule
  ],
  providers: [
    AuthGuardService,
    GenericService
  ]
})
export class SharedModule { }
